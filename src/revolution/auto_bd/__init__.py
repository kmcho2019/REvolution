"""Auto-BD research utilities."""

from revolution.auto_bd.method_specs import (
    AUTO_BD_METHODS_DIR,
    AUTO_BD_SCAFFOLD_DIR,
    FORBIDDEN_DESCRIPTOR_INPUTS,
    AutoBDMethodSpec,
    method_directory,
    method_spec,
    method_specs,
    validate_method_registry,
)
from revolution.auto_bd.motif_descriptor import (
    MOTIF_OCCUPANCY_AXES,
    motif_occupancy_descriptor_values,
)
from revolution.auto_bd.random_descriptor import (
    RANDOM_DESCRIPTOR_SEED,
    RANDOM_HASH_AXES,
    random_hash_descriptor_values,
)
from revolution.auto_bd.stage_dumps import (
    STNOD_STAGE_NAMES,
    YosysStageDumpPlan,
    write_yosys_stage_dump_script,
)
from revolution.auto_bd.sr_pca_descriptor import (
    SR_PCA_AXES,
    SR_RANDOM_RELU_PCA_DESCRIPTOR_VERSION,
    SR_RAW_FEATURE_SCHEMA_VERSION,
    SR_RAW_PCA_DESCRIPTOR_VERSION,
    SR_RFF_PCA_DESCRIPTOR_VERSION,
    SrPcaArtifact,
    fit_sr_random_relu_pca_artifact,
    fit_sr_raw_pca_artifact,
    fit_sr_rff_pca_artifact,
    sr_pca_artifact_from_json,
    sr_pca_artifact_to_json,
    sr_raw_feature_axes,
    sr_raw_feature_values,
    transform_sr_raw_pca,
)
from revolution.auto_bd.sr_vq_descriptor import (
    SR_VQ_AXES,
    SR_VQ_DESCRIPTOR_VERSION,
    SrVqArtifact,
    fit_sr_vq_artifact,
    sr_vq_artifact_from_json,
    sr_vq_artifact_to_json,
    transform_sr_vq,
)
from revolution.auto_bd.trajectory_descriptor import (
    STNOD_TRAJECTORY_AXES,
    synthesis_trajectory_descriptor_values,
)

__all__ = [
    "AUTO_BD_METHODS_DIR",
    "AUTO_BD_SCAFFOLD_DIR",
    "FORBIDDEN_DESCRIPTOR_INPUTS",
    "AutoBDMethodSpec",
    "method_directory",
    "method_spec",
    "method_specs",
    "MOTIF_OCCUPANCY_AXES",
    "motif_occupancy_descriptor_values",
    "RANDOM_DESCRIPTOR_SEED",
    "RANDOM_HASH_AXES",
    "random_hash_descriptor_values",
    "SR_PCA_AXES",
    "SR_RANDOM_RELU_PCA_DESCRIPTOR_VERSION",
    "SR_RAW_FEATURE_SCHEMA_VERSION",
    "SR_RAW_PCA_DESCRIPTOR_VERSION",
    "SR_RFF_PCA_DESCRIPTOR_VERSION",
    "SR_VQ_AXES",
    "SR_VQ_DESCRIPTOR_VERSION",
    "SrPcaArtifact",
    "SrVqArtifact",
    "fit_sr_random_relu_pca_artifact",
    "fit_sr_raw_pca_artifact",
    "fit_sr_rff_pca_artifact",
    "fit_sr_vq_artifact",
    "sr_pca_artifact_from_json",
    "sr_pca_artifact_to_json",
    "sr_raw_feature_axes",
    "sr_raw_feature_values",
    "sr_vq_artifact_from_json",
    "sr_vq_artifact_to_json",
    "transform_sr_raw_pca",
    "transform_sr_vq",
    "STNOD_STAGE_NAMES",
    "STNOD_TRAJECTORY_AXES",
    "synthesis_trajectory_descriptor_values",
    "validate_method_registry",
    "write_yosys_stage_dump_script",
    "YosysStageDumpPlan",
]
