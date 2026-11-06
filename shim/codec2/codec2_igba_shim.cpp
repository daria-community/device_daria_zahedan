// Shim for stock vendor libcodec2_aidl.so which still references the
// deprecated CreateCodec2BlockPool(C2PlatformAllocatorDesc&, ...) overload.
#include <C2PlatformSupport.h>

namespace android {

// Layout-compatible with the deprecated struct (only the name matters for
// symbol mangling; igba is a shared_ptr so its type does not affect layout).
struct C2PlatformAllocatorDesc {
    C2PlatformAllocatorStore::id_t allocatorId;
    std::shared_ptr<void> igba;
    ::android::base::unique_fd waitableFd;
    bool blockFenceSupport;
};

c2_status_t CreateCodec2BlockPool(
        C2PlatformAllocatorDesc &allocator,
        std::shared_ptr<const C2Component> component,
        std::shared_ptr<C2BlockPool> *pool) {
    if (pool == nullptr) {
        return C2_BAD_VALUE;
    }
    pool->reset();
    if (allocator.igba) {
        // IGBA-based pools are not supported by this shim.
        return C2_OMITTED;
    }
    C2PlatformAllocatorDescV2 v2;
    v2.allocatorId = allocator.allocatorId;
    return CreateCodec2BlockPool(v2, component, pool);
}

}  // namespace android
