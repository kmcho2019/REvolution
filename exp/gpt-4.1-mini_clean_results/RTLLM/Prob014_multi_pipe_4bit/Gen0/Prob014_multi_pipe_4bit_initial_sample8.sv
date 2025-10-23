module multi_pipe_4bit #(parameter size = 4)(
    input                   clk,
    input                   rst_n,
    input  [size-1:0]       mul_a,
    input  [size-1:0]       mul_b,
    output reg [2*size-1:0] mul_out
);

// Extend inputs by size zeros at MSB side
wire [2*size-1:0] ext_mul_a = {{size{1'b0}}, mul_a}; // 8 bits
wire [2*size-1:0] ext_mul_b = {{size{1'b0}}, mul_b}; // 8 bits (not used in this way, but consistent)

// Generate partial products for mul_b bits [0:3]
wire [2*size-1:0] partial_products [0:size-1];

genvar i;
generate
    for (i=0; i<size; i=i+1) begin : gen_pp
        assign partial_products[i] = mul_b[i] ? (ext_mul_a << i) : {2*size{1'b0}};
    end
endgenerate

// Pipeline registers: Two levels of registers for intermediate sums
// Stage 1 registers: sum0 for partial_products[0] + partial_products[1]
//                   sum1 for partial_products[2] + partial_products[3]
reg [2*size-1:0] sum0_reg, sum1_reg;
// Stage 2 register: sum2 for sum0_reg + sum1_reg
reg [2*size-1:0] sum2_reg;

// Sequential logic for pipeline registers and output
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum0_reg <= 0;
        sum1_reg <= 0;
        sum2_reg <= 0;
        mul_out  <= 0;
    end else begin
        // First pipeline stage: sum partial products pairs
        sum0_reg <= partial_products[0] + partial_products[1];
        sum1_reg <= partial_products[2] + partial_products[3];
        // Second pipeline stage: sum of stage 1 registers
        sum2_reg <= sum0_reg + sum1_reg;
        // Output register holds final product sum
        mul_out  <= sum2_reg;
    end
end

endmodule