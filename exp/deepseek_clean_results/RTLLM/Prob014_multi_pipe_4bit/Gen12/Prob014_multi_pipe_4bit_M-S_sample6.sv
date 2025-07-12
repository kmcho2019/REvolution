module multi_pipe_4bit (
    input clk,
    input rst_n,
    input [3:0] mul_a,
    input [3:0] mul_b,
    output reg [7:0] mul_out
);

parameter size = 4;

// Pipeline stage 1 registers
reg [7:0] pp0, pp1, pp2, pp3;

// Generate all partial products in parallel
wire [7:0] pp0_next = mul_b[0] ? {4'b0, mul_a} : 8'b0;
wire [7:0] pp1_next = mul_b[1] ? {3'b0, mul_a, 1'b0} : 8'b0;
wire [7:0] pp2_next = mul_b[2] ? {2'b0, mul_a, 2'b0} : 8'b0;
wire [7:0] pp3_next = mul_b[3] ? {1'b0, mul_a, 3'b0} : 8'b0;

// Pipeline stage 2 computation
wire [7:0] sum_next = pp0 + pp1 + pp2 + pp3;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Clear pipeline registers
        pp0 <= 8'b0;
        pp1 <= 8'b0;
        pp2 <= 8'b0;
        pp3 <= 8'b0;
        mul_out <= 8'b0;
    end else begin
        // First pipeline stage: store partial products
        pp0 <= pp0_next;
        pp1 <= pp1_next;
        pp2 <= pp2_next;
        pp3 <= pp3_next;
        
        // Second pipeline stage: compute final sum
        mul_out <= sum_next;
    end
end

endmodule