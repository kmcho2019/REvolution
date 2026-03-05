# sirv_gnrl_dffs Design Specification

## Introduction

The `sirv_gnrl_dffs.v` file implements a collection of general-purpose D flip-flops (DFFs) and latch modules for digital circuit design. These modules offer various combinations of features including load-enable and reset functionality with different reset values.

## Interface

### 1. sirv_gnrl_dfflrs

#### 1.1 Parameter Configuration

| Parameter Name | Default Value | Description |
|----------------|---------------|-------------|
| DW             | 32            | Data width (in bits) |

#### 1.2 Signal Interface

| Port Name | Direction | Width | Description |
|-----------|-----------|-------|-------------|
| lden      | Input     | 1     | Load enable signal |
| dnxt      | Input     | DW    | Input data |
| qout      | Output    | DW    | Output data |
| clk       | Input     | 1     | Clock signal |
| rst_n     | Input     | 1     | Active-low reset signal |

### 2. sirv_gnrl_dfflr

#### 2.1 Parameter Configuration

| Parameter Name | Default Value | Description |
|----------------|---------------|-------------|
| DW             | 32            | Data width (in bits) |

#### 2.2 Signal Interface

| Port Name | Direction | Width | Description |
|-----------|-----------|-------|-------------|
| lden      | Input     | 1     | Load enable signal |
| dnxt      | Input     | DW    | Input data |
| qout      | Output    | DW    | Output data |
| clk       | Input     | 1     | Clock signal |
| rst_n     | Input     | 1     | Active-low reset signal |

### 3. sirv_gnrl_dffl

#### 3.1 Parameter Configuration

| Parameter Name | Default Value | Description |
|----------------|---------------|-------------|
| DW             | 32            | Data width (in bits) |

#### 3.2 Signal Interface

| Port Name | Direction | Width | Description |
|-----------|-----------|-------|-------------|
| lden      | Input     | 1     | Load enable signal |
| dnxt      | Input     | DW    | Input data |
| qout      | Output    | DW    | Output data |
| clk       | Input     | 1     | Clock signal |

### 4. sirv_gnrl_dffrs

#### 4.1 Parameter Configuration

| Parameter Name | Default Value | Description |
|----------------|---------------|-------------|
| DW             | 32            | Data width (in bits) |

#### 4.2 Signal Interface

| Port Name | Direction | Width | Description |
|-----------|-----------|-------|-------------|
| dnxt      | Input     | DW    | Input data |
| qout      | Output    | DW    | Output data |
| clk       | Input     | 1     | Clock signal |
| rst_n     | Input     | 1     | Active-low reset signal |

### 5. sirv_gnrl_dffr

#### 5.1 Parameter Configuration

| Parameter Name | Default Value | Description |
|----------------|---------------|-------------|
| DW             | 32            | Data width (in bits) |

#### 5.2 Signal Interface

| Port Name | Direction | Width | Description |
|-----------|-----------|-------|-------------|
| dnxt      | Input     | DW    | Input data |
| qout      | Output    | DW    | Output data |
| clk       | Input     | 1     | Clock signal |
| rst_n     | Input     | 1     | Active-low reset signal |

### 6. sirv_gnrl_ltch

#### 6.1 Parameter Configuration

| Parameter Name | Default Value | Description |
|----------------|---------------|-------------|
| DW             | 32            | Data width (in bits) |

#### 6.2 Signal Interface

| Port Name | Direction | Width | Description |
|-----------|-----------|-------|-------------|
| lden      | Input     | 1     | Latch enable signal |
| dnxt      | Input     | DW    | Input data |
| qout      | Output    | DW    | Output data |
