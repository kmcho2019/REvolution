module multi_pipe_4bit #(
    parameter size = 4
) (
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

// Extended multiplicand with zeros
wire [2*size-1:0] a_ext = {{size{1'b0}}, mul_a};

// Partial products
wire [2*size-1:0] pp0 = mul_b[0] ? a_ext : 0;
wire [2*size-1:0] pp1 = mul_b[1] ? (a_ext << 1) : 0;
wire [2*size-1:0] pp2 = mul_b[2] ? (a_ext << 2) : 0;
wire [2*size-1:0] pp3 = mul_b[3] ? (a_ext << 3) : 0;

// Pipeline registers
reg [2*size-1:0] stage1_sum;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all pipeline registers
        stage1_sum <= 0;
        mul_out <= 0;
    end else begin
        // First pipeline stage: sum of first two partial products
        stage1_sum <= pp0 + pp1;
        
        // Second pipeline stage: final sum
        mul_out <= stage1_sum + pp2 + pp3;
    end
end

endmodule