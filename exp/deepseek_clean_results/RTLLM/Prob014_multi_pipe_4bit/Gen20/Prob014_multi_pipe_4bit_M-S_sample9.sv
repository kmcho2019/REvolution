module multi_pipe_4bit #(
    parameter size = 4
) (
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

// Pipeline registers
reg [2*size-1:0] a_ext, b_ext;
reg [2*size-1:0] sum01;

// Zero-extended inputs
wire [2*size-1:0] a_ext_w = {{size{1'b0}}, mul_a};
wire [2*size-1:0] b_ext_w = {{size{1'b0}}, mul_b};

// Partial products
wire [2*size-1:0] pp0 = b_ext_w[0] ? a_ext_w : 0;
wire [2*size-1:0] pp1 = b_ext_w[1] ? (a_ext_w << 1) : 0;
wire [2*size-1:0] pp2 = b_ext_w[2] ? (a_ext_w << 2) : 0;
wire [2*size-1:0] pp3 = b_ext_w[3] ? (a_ext_w << 3) : 0;

// Pipeline stage 1: Register inputs and compute first sum
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        a_ext <= 0;
        b_ext <= 0;
        sum01 <= 0;
    end else begin
        a_ext <= a_ext_w;
        b_ext <= b_ext_w;
        sum01 <= pp0 + pp1;  // First stage adds bits 0-1
    end
end

// Pipeline stage 2: Compute final sum and register output
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_out <= 0;
    end else begin
        mul_out <= sum01 + pp2 + pp3;  // Second stage adds bits 2-3
    end
end

endmodule