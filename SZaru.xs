#define PERL_NO_GET_CONTEXT
#ifdef __cplusplus
extern "C" {
#endif
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "ppport.h"

#ifdef __cplusplus
}
#endif

#include <stdint.h>
#include <string>
#include <vector>
#include "szaru.h"

using namespace std;

class TopEstimator {
private:
  SZaru::TopEstimator<int32_t> *impl_;
  
public:
  TopEstimator(int32_t num_tops) :
      impl_(SZaru::TopEstimator<int32_t>::Create(num_tops)) {
  }

  ~TopEstimator() {
    delete impl_;
  }
  
  void add_elem(const char *elem) {
    impl_->AddElem(string(elem));
  }

  void add_weighted_elem(const char *elem, int32_t weight) {
    impl_->AddWeightedElem(string(elem), weight);
  }
  
  void estimate_impl(vector<SZaru::TopEstimator<int32_t>::Elem> &tops) {
    impl_->Estimate(tops);
  }
};

class QuantileEstimator {
private:
  SZaru::QuantileEstimator<int32_t> *impl_;
  
public:
  QuantileEstimator(int32_t num_quantiles) :
      impl_(SZaru::QuantileEstimator<int32_t>::Create(num_quantiles)) {
  }

  ~QuantileEstimator() {
    delete impl_;
  }
  
  void add_elem(int32_t elem) {
    impl_->AddElem(elem);
  }

  void estimate_impl(vector<int32_t> &quantiles) {
    impl_->Estimate(quantiles);
  }
};

MODULE = Acme::SZaru		PACKAGE = Acme::SZaru::TopEstimator

PROTOTYPES: ENABLE

TopEstimator *
TopEstimator::new(int num_tops)

void
TopEstimator::DESTROY()

void
TopEstimator::add_elem(const char* name)

void
TopEstimator::add_weighted_elem(const char* name, int32_t weight)

SV *
TopEstimator::estimate()
PPCODE:
{
    AV* ar;
    ar = (AV*)sv_2mortal((SV*)newAV());

    std::vector<SZaru::TopEstimator<int32_t>::Elem> e;
    THIS->estimate_impl(e);
    std::vector<SZaru::TopEstimator<int32_t>::Elem>::iterator it = e.begin();
    while (it != e.end()) {
        HV* h = (HV*)sv_2mortal((SV*)newHV());
        hv_store(h, "value",  5, newSVpv(it->value.c_str(), it->value.size()), 0);
        hv_store(h, "weight", 6, newSVuv(it->weight), 0);
        av_push(ar, newRV_inc((SV*)h));
        it++;
    }

    ST(0) = sv_2mortal(newRV_inc((SV*)ar));
    XSRETURN(1);
}

MODULE = Acme::SZaru		PACKAGE = Acme::SZaru::QuantileEstimator

PROTOTYPES: ENABLE

QuantileEstimator *
QuantileEstimator::new(int num_quantiles)

void
QuantileEstimator::DESTROY()

void
QuantileEstimator::add_elem(int32_t elem)

SV *
QuantileEstimator::estimate()
PPCODE:
{
    AV* ar;
    ar = (AV*)sv_2mortal((SV*)newAV());

    std::vector<int32_t> e;
    THIS->estimate_impl(e);
    std::vector<int32_t>::iterator it = e.begin();
    while (it != e.end()) {
        av_push(ar, newRV_inc(newSVuv(*it)));
        it++;
    }

    ST(0) = sv_2mortal(newRV_inc((SV*)ar));
    XSRETURN(1);
}
