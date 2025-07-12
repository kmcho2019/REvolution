module multi_pipe_4bit #(
    parameter size = 4
) (
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

// Extend multiplicand
wire [2*size-1:0] a_ext = {{size{1'b0}}, mul_a};

// First pipeline stage: Partial products and initial sums
reg [2*size-1:0] pp0, pp1, pp2, pp3;
reg [2*size-1:0] sum01, sum23;

// Second pipeline stage: Final sum
reg [2*size-1:0] final_sum;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Clear all pipeline registers
        {pp0, pp1, pp2, pp3} <= 0;
        {sum01, sum23} <= 0;
        final_sum <= 0;
        mul_out <= 0;
    end else begin
        // Stage 1: Generate partial products and first-level sums
        pp0 <= mul_b[0] ? a_ext : 0;
        pp1 <= mul_b[1] ? (a_ext << 1) : 0;
        pp2 <= mul_b[2] ? (a_ext << 2) : 0;
        pp3 <= mul_b[3] ? (a_ext << 3) : 0;
        
        sum01 <= pp0 + pp1;
        sum23 <= pp2 + pp3;
        
        // Stage 2: Final sum
        final_sum <= sum01 + sum23;
        
        // Output
        mul_out <= final_sum;
    end
end

endmodule