module multi_pipe_8bit (
    input clk,
    input rst_n,
    input mul_en_in,
    input [7:0] mul_a,
    input [7:0] mul_b,
    output reg mul_en_out,
    output reg [15:0] mul_out
);

// Pipeline stage 1: Input sampling
reg [7:0] a_stage1, b_stage1;
reg en_stage1;

// Partial products generation
wire [15:0] partial_products [7:0];
genvar i;
generate
    for (i = 0; i < 8; i = i + 1) begin : pp_gen
        assign partial_products[i] = b_stage1[i] ? {8'b0, a_stage1} << i : 16'b0;
    end
endgenerate

// Pipeline stage 2: First level additions
reg [15:0] sum_stage2_0, sum_stage2_1, sum_stage2_2, sum_stage2_3;
reg en_stage2;

// Pipeline stage 3: Second level additions
reg [15:0] sum_stage3_0, sum_stage3_1;
reg en_stage3;

// Pipeline stage 4: Final addition
reg [15:0] sum_stage4;
reg en_stage4;

// Pipeline stage 1: Input sampling
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        a_stage1 <= 8'b0;
        b_stage1 <= 8'b0;
        en_stage1 <= 1'b0;
    end else begin
        en_stage1 <= mul_en_in;
        if (mul_en_in) begin
            a_stage1 <= mul_a;
            b_stage1 <= mul_b;
        end
    end
end

// Pipeline stage 2: First level additions (combinational)
wire [15:0] sum_stage2_0_wire = partial_products[0] + partial_products[1];
wire [15:0] sum_stage2_1_wire = partial_products[2] + partial_products[3];
wire [15:0] sum_stage2_2_wire = partial_products[4] + partial_products[5];
wire [15:0] sum_stage2_3_wire = partial_products[6] + partial_products[7];

// Pipeline stage 2: Register outputs
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum_stage2_0 <= 16'b0;
        sum_stage2_1 <= 16'b0;
        sum_stage2_2 <= 16'b0;
        sum_stage2_3 <= 16'b0;
        en_stage2 <= 1'b0;
    end else begin
        sum_stage2_0 <= sum_stage2_0_wire;
        sum_stage2_1 <= sum_stage2_1_wire;
        sum_stage2_2 <= sum_stage2_2_wire;
        sum_stage2_3 <= sum_stage2_3_wire;
        en_stage2 <= en_stage1;
    end
end

// Pipeline stage 3: Second level additions (combinational)
wire [15:0] sum_stage3_0_wire = sum_stage2_0 + sum_stage2_1;
wire [15:0] sum_stage3_1_wire = sum_stage2_2 + sum_stage2_3;

// Pipeline stage 3: Register outputs
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum_stage3_0 <= 16'b0;
        sum_stage3_1 <= 16'b0;
        en_stage3 <= 1'b0;
    end else begin
        sum_stage3_0 <= sum_stage3_0_wire;
        sum_stage3_1 <= sum_stage3_1_wire;
        en_stage3 <= en_stage2;
    end
end

// Pipeline stage 4: Final addition (combinational)
wire [15:0] sum_stage4_wire = sum_stage3_0 + sum_stage3_1;

// Pipeline stage 4: Register outputs
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum_stage4 <= 16'b0;
        en_stage4 <= 1'b0;
    end else begin
        sum_stage4 <= sum_stage4_wire;
        en_stage4 <= en_stage3;
    end
end

// Output stage
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_out <= 16'b0;
        mul_en_out <= 1'b0;
    end else begin
        mul_out <= sum_stage4;
        mul_en_out <= en_stage4;
    end
end

endmodule