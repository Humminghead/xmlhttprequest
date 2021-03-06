#pragma once

#include <map>
#include <memory>
#include <string>

namespace network {

class HeaderValue;
class Header;

class Request {
public:
  Request();
  ~Request() = default;

  Request(Request &&) = default;
  Request &operator=(Request &&) = default;

  Request(const Request &) = delete;
  Request &operator=(const Request &) = delete;

  void scheme(const char *value, const size_t len) noexcept;
  void host(const char *value, const size_t len) noexcept;
  void method(const char *value, const size_t len) noexcept;

  std::string scheme() const;
  std::string host() const;
  std::string method() const;

  std::string find(const std::string &) const;

  Header &header();
  void header(std::string name, HeaderValue &&value) noexcept;

private:
  struct Impl;
  std::unique_ptr<Impl, void (*)(Impl *)> d;
};

} // namespace network
