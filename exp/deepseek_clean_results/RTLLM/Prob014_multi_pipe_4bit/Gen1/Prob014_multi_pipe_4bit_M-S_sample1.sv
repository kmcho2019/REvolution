module multi_pipe_4bit (
    input clk,
    input rst_n,
    input [3:0] mul_a,
    input [3:0] mul_b,
    output reg [7:0] mul_out
);

// Partial products
wire [7:0] pp0 = mul_b[0] ? {4'b0, mul_a}       : 8'd0;
wire [7:0] pp1 = mul_b[1] ? {3'b0, mul_a, 1'b0} : 8'd0;
wire [7:0] pp2 = mul_b[2] ? {2'b0, mul_a, 2'b0} : 8'd0;
wire [7:0] pp3 = mul_b[3] ? {1'b0, mul_a, 3'b0} : 8'd0;

// Pipeline register
reg [7:0] intermediate_sum;

// Single pipeline stage
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        intermediate_sum <= 8'd0;
        mul_out <= 8'd0;
    end else begin
        // First cycle: sum pp0 and pp1
        // Second cycle: add pp2 and pp3 to previous sum
        intermediate_sum <= pp0 + pp1;
        mul_out <= intermediate_sum + pp2 + pp3;
    end
end

endmodule