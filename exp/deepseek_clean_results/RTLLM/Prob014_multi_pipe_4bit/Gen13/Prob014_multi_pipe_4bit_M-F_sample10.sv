module multi_pipe_4bit (
    input clk,
    input rst_n,
    input [3:0] mul_a,
    input [3:0] mul_b,
    output reg [7:0] mul_out
);

// Pipeline stage 1 registers (partial products)
reg [7:0] pp [0:3];

// Generate all partial products
wire [7:0] pp0 = mul_b[0] ? {4'b0, mul_a} : 8'b0;
wire [7:0] pp1 = mul_b[1] ? {3'b0, mul_a, 1'b0} : 8'b0;
wire [7:0] pp2 = mul_b[2] ? {2'b0, mul_a, 2'b0} : 8'b0;
wire [7:0] pp3 = mul_b[3] ? {1'b0, mul_a, 3'b0} : 8'b0;

// Pipeline stage 2 computation
wire [7:0] sum = pp[0] + pp[1] + pp[2] + pp[3];

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Clear all pipeline registers
        pp[0] <= 8'b0;
        pp[1] <= 8'b0;
        pp[2] <= 8'b0;
        pp[3] <= 8'b0;
        mul_out <= 8'b0;
    end else begin
        // First pipeline stage: register partial products
        pp[0] <= pp0;
        pp[1] <= pp1;
        pp[2] <= pp2;
        pp[3] <= pp3;
        
        // Second pipeline stage: compute and register final sum
        mul_out <= sum;
    end
end

endmodule