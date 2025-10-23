module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

// Pipeline registers
reg [511:0] stage1, stage2, stage3;

// Clock gating logic
wire compute_en = ~load;

// Boundary-extended versions for each pipeline stage
wire [129:0] ext_stage0 = {1'b0, q[127:0], 1'b0};
wire [129:0] ext_stage1 = {1'b0, q[255:128], 1'b0};
wire [129:0] ext_stage2 = {1'b0, q[383:256], 1'b0};
wire [129:0] ext_stage3 = {1'b0, q[511:384], 1'b0};

// Pipeline stage 1 (bits 0-127)
always @(posedge clk) if (compute_en) begin
    for (integer i=0; i<128; i=i+1)
        stage1[i] <= ext_stage0[i] ^ ext_stage0[i+2];
end

// Pipeline stage 2 (bits 128-255)
always @(posedge clk) if (compute_en) begin
    for (integer i=0; i<128; i=i+1)
        stage2[i] <= ext_stage1[i] ^ ext_stage1[i+2];
end

// Pipeline stage 3 (bits 256-383)
always @(posedge clk) if (compute_en) begin
    for (integer i=0; i<128; i=i+1)
        stage3[i] <= ext_stage2[i] ^ ext_stage2[i+2];
end

// Final stage and output (bits 384-511)
wire [129:0] ext_stage4 = {1'b0, stage3, 1'b0};
always @(posedge clk) begin
    if (load) begin
        q <= data;
    end else if (compute_en) begin
        // Combine all pipeline stages
        q[127:0] <= stage1;
        q[255:128] <= stage2;
        q[383:256] <= stage3;
        // Compute final stage
        for (integer i=0; i<128; i=i+1)
            q[511-i] <= ext_stage4[i] ^ ext_stage4[i+2];
    end
end

endmodule