#ifndef LB_optional_optional_HeaderPlusPlus
#define LB_optional_optional_HeaderPlusPlus

#include <type_traits>
#include <cstddef>
#include <algorithm>
#include <iterator>
#include <memory>

namespace LB
{
	namespace optional
	{
		template<typename T>
		struct optional final
		{
			using Value_t = T;
			optional(std::nullptr_t = nullptr) noexcept
			{
			}
			template<typename... Args>
			optional(Args &&... args) noexcept
			{
				new (&data) T{std::forward<Args>(args)...};
				valid = true;
			}
			optional(optional const &from) noexcept
			: optional(static_cast<T const &>(from))
			{
			}
			optional &operator=(optional from) noexcept
			{
				from.valid = false;
				std::swap_ranges(std::begin(data), std::end(data), std::begin(from.data));
				valid = true;
				return *this;
			}
			optional(optional &&from) noexcept
			{
				*this = from;
			}
			optional &operator=(optional &&from) noexcept
			{
				bool va = valid, vb = from.valid;
				from.valid = false;
				std::swap_ranges(std::begin(data), std::end(data), std::begin(from.data));
				valid = vb;
				from.valid = va;
				return *this;
			}
			~optional() noexcept
			{
				if(valid)
				{
					valid = false;
					static_cast<T &>(*this).~T();
				}
			}

			operator bool() const noexcept
			{
				return valid;
			}
			operator T &() noexcept
			{
				return *reinterpret_cast<T *>(data);
			}
			operator T const &() const noexcept
			{
				return *reinterpret_cast<T const *>(data);
			}

		private:
			alignas(T) char data[sizeof(T)];
			bool valid = false;
		};
		template<typename T>
		struct optional<T &> final
		{
			using Value_t = T &;
			optional(std::nullptr_t = nullptr) noexcept
			: v(nullptr)
			{
			}
			optional(T &t) noexcept
			: v(std::addressof(t))
			{
			}
			optional(optional const &) = default;
			optional &operator=(optional const &) = default;
			optional(optional &&) = default;
			optional &operator=(optional &&) = default;
			~optional() = default;

			operator bool() const noexcept
			{
				return v != nullptr;
			}
			operator T &() noexcept
			{
				return *v;
			}
			operator T const &() const noexcept
			{
				return *v;
			}

		private:
			T *v;
		};
	}
}

#endif
