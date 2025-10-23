module multi_pipe_4bit #(parameter size = 4)(
    input                   clk,
    input                   rst_n,
    input  [size-1:0]       mul_a,
    input  [size-1:0]       mul_b,
    output reg [2*size-1:0] mul_out
);

// Extend multiplicand by size zeros at MSB to 8 bits
wire [2*size-1:0] ext_mul_a = {{size{1'b0}}, mul_a};

// Generate partial products
wire [2*size-1:0] pp0 = mul_b[0] ? (ext_mul_a << 0) : 0;
wire [2*size-1:0] pp1 = mul_b[1] ? (ext_mul_a << 1) : 0;
wire [2*size-1:0] pp2 = mul_b[2] ? (ext_mul_a << 2) : 0;
wire [2*size-1:0] pp3 = mul_b[3] ? (ext_mul_a << 3) : 0;

// Pipeline stage registers
reg [2*size-1:0] stage1_sum0, stage1_sum1; // sums of partial products (bits 0-1 and bits 2-3)
reg [2*size-1:0] stage2_sum;               // sum of stage1_sum0 and stage1_sum1

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage1_sum0 <= 0;
        stage1_sum1 <= 0;
        stage2_sum  <= 0;
        mul_out     <= 0;
    end else begin
        // First pipeline stage: sum partial products pairs
        stage1_sum0 <= pp0 + pp1;
        stage1_sum1 <= pp2 + pp3;
        // Second pipeline stage: sum of the above sums
        stage2_sum  <= stage1_sum0 + stage1_sum1;
        // Output register holds final product
        mul_out     <= stage2_sum;
    end
end

endmodule