/*
 * Legacy Codec2 block-pool ABI compatibility shim.
 *
 * Old vendor blobs call CreateCodec2BlockPool() with the legacy
 * C2PlatformAllocatorDesc. Translate it to C2PlatformAllocatorDescV2.
 */

#include <memory>
#include <utility>
#include <vector>

#include <android-base/unique_fd.h>
#include <log/log.h>

#include <C2BlockInternal.h>
#include <C2IgbaBufferPriv.h>
#include <C2IgbaInterfaceImpl.h>
#include <C2PlatformSupport.h>

namespace android {

using LegacyIgba =
        ::aidl::android::hardware::media::c2::IGraphicBufferAllocator;

// Exact legacy ABI layout. Do not reorder, add or remove fields.
struct C2PlatformAllocatorDescLegacy {
    C2PlatformAllocatorStore::id_t allocatorId;
    std::shared_ptr<LegacyIgba> igba;
    ::android::base::unique_fd waitableFd;
    bool blockFenceSupport;
};

static C2PlatformAllocatorDescV2 toV2(C2PlatformAllocatorDescLegacy& legacy) {
    C2PlatformAllocatorDescV2 v2{};
    v2.allocatorId = legacy.allocatorId;
    v2.blockFenceSupport = legacy.blockFenceSupport;
    if (legacy.igba) {
        v2.igba = std::make_shared<C2IgbaInterfaceImpl>(legacy.igba);
        v2.waitableFd = std::move(legacy.waitableFd);
    }
    return v2;
}

// Single-component overload.
int createCodec2BlockPool(
        C2PlatformAllocatorDescLegacy& allocatorParam,
        std::shared_ptr<const C2Component> component,
        std::shared_ptr<C2BlockPool>* pool)
    asm("_ZN7android21CreateCodec2BlockPoolERNS_23C2PlatformAllocatorDescENSt3__110shared_ptrIK11C2ComponentEEPNS3_I11C2BlockPoolEE");

int createCodec2BlockPool(
        C2PlatformAllocatorDescLegacy& allocatorParam,
        std::shared_ptr<const C2Component> component,
        std::shared_ptr<C2BlockPool>* pool) {
    if (!pool) {
        return C2_BAD_VALUE;
    }
    pool->reset();

    C2PlatformAllocatorDescV2 v2 = toV2(allocatorParam);
    const int ret = ::android::CreateCodec2BlockPool(v2, component, pool);

    ALOGW("shim: CreateCodec2BlockPool allocator=%u igba=%s ret=%d",
          static_cast<unsigned>(allocatorParam.allocatorId),
          v2.igba ? "YES" : "NULL", ret);
    return ret;
}

// Vector-of-components overload.
int createCodec2BlockPoolVec(
        C2PlatformAllocatorDescLegacy& allocatorParam,
        const std::vector<std::shared_ptr<const C2Component>>& components,
        std::shared_ptr<C2BlockPool>* pool)
    asm("_ZN7android21CreateCodec2BlockPoolERNS_23C2PlatformAllocatorDescERKNSt3__16vectorINS2_10shared_ptrIK11C2ComponentEENS2_9allocatorIS7_EEEEPNS4_I11C2BlockPoolEE");

int createCodec2BlockPoolVec(
        C2PlatformAllocatorDescLegacy& allocatorParam,
        const std::vector<std::shared_ptr<const C2Component>>& components,
        std::shared_ptr<C2BlockPool>* pool) {
    if (!pool) {
        return C2_BAD_VALUE;
    }
    pool->reset();

    C2PlatformAllocatorDescV2 v2 = toV2(allocatorParam);
    const int ret = ::android::CreateCodec2BlockPool(v2, components, pool);

    ALOGW("shim: CreateCodec2BlockPool(vec) allocator=%u igba=%s ret=%d",
          static_cast<unsigned>(allocatorParam.allocatorId),
          v2.igba ? "YES" : "NULL", ret);
    return ret;
}

}  // namespace android
