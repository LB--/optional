#undef NDEBUG
#include "optional.hpp"

#include <cassert>

int main()
{
	using namespace LB::optional;

	optional<int> o1;
	assert(!o1);
	o1 = 7;
	assert(o1);
	assert(o1.value() == 7);
	auto o2 = o1;
	assert(o2);
	assert(o2.value() == 7);
	o1 = nullptr;
	assert(!o1);
}
