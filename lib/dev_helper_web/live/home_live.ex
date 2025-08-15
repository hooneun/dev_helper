defmodule DevHelperWeb.HomeLive do
  use DevHelperWeb, :live_view

  alias DevHelper.Accounts

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <div class="mx-auto space-y-4">
        <!-- Hero Section -->
        <div class="hero">
          <div class="hero-content text-center max-w-6xl">
            <div class="grid lg:grid-cols-2 gap-16 items-center">
              <!-- Left Content -->
              <div class="space-y-8">
                <!-- Icon with Animation -->
                <div class="flex justify-center lg:justify-start">
                  <div class="relative">
                    <div class="w-24 h-24 rounded-2xl bg-gradient-to-br from-primary to-secondary flex items-center justify-center shadow-xl animate-pulse">
                      <svg class="w-12 h-12 text-white" fill="currentColor" viewBox="0 0 24 24">
                        <path d="M9.4 16.6L4.8 12l4.6-4.6L8 6l-6 6 6 6 1.4-1.4zm5.2 0L19.2 12l-4.6-4.6L16 6l6 6-6 6-1.4-1.4z" />
                      </svg>
                    </div>
                    <div class="absolute -top-2 -right-2 w-6 h-6 bg-accent rounded-full flex items-center justify-center">
                      <svg class="w-3 h-3 text-white" fill="currentColor" viewBox="0 0 24 24">
                        <path d="M13 3l3.293 3.293-7 7 1.414 1.414 7-7L21 11V3z" />
                        <path d="M19 13v6a2 2 0 01-2 2H5a2 2 0 01-2-2V7a2 2 0 012-2h6" />
                      </svg>
                    </div>
                  </div>
                </div>
                
    <!-- Title and Description -->
                <div class="space-y-6">
                  <h1 class="text-6xl lg:text-7xl font-bold bg-gradient-to-r from-primary to-secondary bg-clip-text text-transparent">
                    DevHelper
                  </h1>
                  <div class="space-y-4">
                    <p class="text-xl lg:text-2xl text-base-content/80 leading-relaxed">
                      개발자를 위한 <span class="font-semibold text-primary">스마트 명령어 저장소</span>
                    </p>
                    <p class="text-lg text-base-content/60">
                      자주 사용하지만 기억하기 어려운 명령어들을<br /> 체계적으로 정리하고 빠르게 찾아보세요
                    </p>
                  </div>
                </div>
                
    <!-- Action Buttons -->
                <div class="flex flex-col sm:flex-row gap-4 justify-center lg:justify-start">
                  <.link
                    navigate="/commands"
                    class="btn btn-primary btn-lg group relative overflow-hidden"
                  >
                    <span class="relative z-10 flex items-center gap-2">
                      <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path
                          stroke-linecap="round"
                          stroke-linejoin="round"
                          stroke-width="2"
                          d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"
                        />
                      </svg>
                      명령어 탐색하기
                    </span>
                    <div class="absolute inset-0 bg-gradient-to-r from-primary-focus to-secondary opacity-0 group-hover:opacity-100 transition-opacity duration-300">
                    </div>
                  </.link>

                  <%= if @current_scope do %>
                    <.link
                      navigate="/commands/new"
                      class="btn btn-outline btn-lg group"
                    >
                      <span class="flex items-center gap-2">
                        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                          <path
                            stroke-linecap="round"
                            stroke-linejoin="round"
                            stroke-width="2"
                            d="M12 6v6m0 0v6m0-6h6m-6 0H6"
                          />
                        </svg>
                        새 명령어 추가
                      </span>
                    </.link>
                  <% else %>
                    <.link
                      navigate="/users/register"
                      class="btn btn-outline btn-lg group"
                    >
                      <span class="flex items-center gap-2">
                        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                          <path
                            stroke-linecap="round"
                            stroke-linejoin="round"
                            stroke-width="2"
                            d="M13 7l5 5m0 0l-5 5m5-5H6"
                          />
                        </svg>
                        시작하기
                      </span>
                    </.link>
                  <% end %>
                </div>
              </div>
              
    <!-- Right Visual -->
              <div class="hidden lg:block">
                <div class="relative">
                  <!-- Mock Terminal -->
                  <div class="bg-base-300 rounded-2xl shadow-2xl p-6 border border-base-content/10">
                    <div class="flex items-center gap-2 mb-4 pb-4 border-b border-base-content/10">
                      <div class="w-3 h-3 rounded-full bg-error"></div>
                      <div class="w-3 h-3 rounded-full bg-warning"></div>
                      <div class="w-3 h-3 rounded-full bg-success"></div>
                      <span class="ml-2 text-sm text-base-content/60 font-mono">terminal</span>
                    </div>
                    <div class="space-y-3 font-mono text-sm">
                      <div class="flex items-center">
                        <span class="text-success">$</span>
                        <span class="ml-2 text-base-content/80">docker run -d --name app</span>
                        <span class="ml-2 animate-pulse">|</span>
                      </div>
                      <div class="text-primary">Starting container...</div>
                      <div class="flex items-center">
                        <span class="text-success">$</span>
                        <span class="ml-2 text-base-content/60">
                          git commit -m "feat: add new feature"
                        </span>
                      </div>
                      <div class="flex items-center">
                        <span class="text-success">$</span>
                        <span class="ml-2 text-base-content/60">
                          npm install --save-dev typescript
                        </span>
                      </div>
                    </div>
                  </div>
                  
    <!-- Floating Cards -->
                  <div class="absolute -top-4 -right-4 bg-primary text-primary-content px-4 py-2 rounded-full text-sm font-medium shadow-lg animate-bounce">
                    💡 빠른 검색
                  </div>
                  <div class="absolute -bottom-4 -left-4 bg-secondary text-secondary-content px-4 py-2 rounded-full text-sm font-medium shadow-lg animate-pulse">
                    🚀 효율성 UP
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
        
    <!-- Features Section -->
        <div class="container mx-auto px-4 py-16">
          <div class="grid md:grid-cols-3 gap-8">
            <div class="card bg-base-100 shadow-xl border border-base-content/5 hover:shadow-2xl transition-shadow duration-300">
              <div class="card-body text-center">
                <div class="mx-auto w-16 h-16 rounded-2xl bg-primary/10 flex items-center justify-center mb-4">
                  <svg
                    class="w-8 h-8 text-primary"
                    fill="none"
                    stroke="currentColor"
                    viewBox="0 0 24 24"
                  >
                    <path
                      stroke-linecap="round"
                      stroke-linejoin="round"
                      stroke-width="2"
                      d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"
                    />
                  </svg>
                </div>
                <h3 class="card-title justify-center text-lg">빠른 검색</h3>
                <p class="text-base-content/70">키워드나 태그로 필요한 명령어를 즉시 찾아보세요</p>
              </div>
            </div>

            <div class="card bg-base-100 shadow-xl border border-base-content/5 hover:shadow-2xl transition-shadow duration-300">
              <div class="card-body text-center">
                <div class="mx-auto w-16 h-16 rounded-2xl bg-secondary/10 flex items-center justify-center mb-4">
                  <svg
                    class="w-8 h-8 text-secondary"
                    fill="none"
                    stroke="currentColor"
                    viewBox="0 0 24 24"
                  >
                    <path
                      stroke-linecap="round"
                      stroke-linejoin="round"
                      stroke-width="2"
                      d="M7 7h.01M7 3h5c.512 0 1.024.195 1.414.586l7 7a2 2 0 010 2.828l-7 7a2 2 0 01-2.828 0l-7-7A1.994 1.994 0 013 12V7a4 4 0 014-4z"
                    />
                  </svg>
                </div>
                <h3 class="card-title justify-center text-lg">스마트 태그</h3>
                <p class="text-base-content/70">태그 시스템으로 명령어를 체계적으로 분류하고 관리하세요</p>
              </div>
            </div>

            <div class="card bg-base-100 shadow-xl border border-base-content/5 hover:shadow-2xl transition-shadow duration-300">
              <div class="card-body text-center">
                <div class="mx-auto w-16 h-16 rounded-2xl bg-accent/10 flex items-center justify-center mb-4">
                  <svg
                    class="w-8 h-8 text-accent"
                    fill="none"
                    stroke="currentColor"
                    viewBox="0 0 24 24"
                  >
                    <path
                      stroke-linecap="round"
                      stroke-linejoin="round"
                      stroke-width="2"
                      d="M8 16H6a2 2 0 01-2-2V6a2 2 0 012-2h8a2 2 0 012 2v2m-6 12h8a2 2 0 002-2v-8a2 2 0 00-2-2h-8a2 2 0 00-2 2v8a2 2 0 002 2z"
                    />
                  </svg>
                </div>
                <h3 class="card-title justify-center text-lg">원클릭 복사</h3>
                <p class="text-base-content/70">클릭 한 번으로 명령어를 클립보드에 복사하세요</p>
              </div>
            </div>
          </div>
        </div>
      </div>
    </Layouts.app>
    """
  end
end
