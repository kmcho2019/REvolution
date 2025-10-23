module multi_pipe_4bit #(
    parameter size = 4
)(
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

localparam ext_size = 2*size;

// Input zero detection for clock gating
wire inputs_non_zero = |mul_a || |mul_b;
wire pipeline_enable = inputs_non_zero || !rst_n;

// Partial products generation (combinational)
wire [ext_size-1:0] pp0 = mul_b[0] ? {{size{1'b0}}, mul_a}       : {ext_size{1'b0}};
wire [ext_size-1:0] pp1 = mul_b[1] ? {{size-1{1'b0}}, mul_a, 1'b0} : {ext_size{1'b0}};
wire [ext_size-1:0] pp2 = mul_b[2] ? {{size-2{1'b0}}, mul_a, 2'b0} : {ext_size{1'b0}};
wire [ext_size-1:0] pp3 = mul_b[3] ? {{size-3{1'b0}}, mul_a, 3'b0} : {ext_size{1'b0}};

// Pipeline Stage 1: Combined Partial Product Registers
reg [ext_size-1:0] pp01_reg, pp23_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        pp01_reg <= {ext_size{1'b0}};
        pp23_reg <= {ext_size{1'b0}};
    end else if (pipeline_enable) begin
        pp01_reg <= pp0 + pp1;  // First stage addition
        pp23_reg <= pp2 + pp3;  // First stage addition
    end
end

// Pipeline Stage 2: Final Sum Register
reg [ext_size-1:0] sum_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum_reg <= {ext_size{1'b0}};
    end else if (pipeline_enable) begin
        sum_reg <= pp01_reg + pp23_reg;
    end
end

// Output register
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_out <= {ext_size{1'b0}};
    end else begin
        mul_out <= sum_reg;
    end
end

endmodule