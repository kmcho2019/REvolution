module multi_pipe_4bit (
    input clk,
    input rst_n,
    input [3:0] mul_a,
    input [3:0] mul_b,
    output reg [7:0] mul_out
);

// Single pipeline register
reg [7:0] accum;

// Generate partial products
wire [7:0] pp0 = mul_b[0] ? {4'b0, mul_a} : 8'b0;
wire [7:0] pp1 = mul_b[1] ? {3'b0, mul_a, 1'b0} : 8'b0;
wire [7:0] pp2 = mul_b[2] ? {2'b0, mul_a, 2'b0} : 8'b0;
wire [7:0] pp3 = mul_b[3] ? {1'b0, mul_a, 3'b0} : 8'b0;

// Intermediate sums
wire [7:0] sum1 = pp0 + pp1;
wire [7:0] sum2 = pp2 + pp3;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        accum <= 8'b0;
        mul_out <= 8'b0;
    end else begin
        // First stage: store first partial sum
        accum <= sum1;
        
        // Second stage: complete the addition
        mul_out <= accum + sum2;
    end
end

endmodule