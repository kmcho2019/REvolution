module multi_pipe_4bit #(parameter size = 4)(
    input                   clk,
    input                   rst_n,
    input      [size-1:0]   mul_a,
    input      [size-1:0]   mul_b,
    output reg [2*size-1:0] mul_out
);

// Extend inputs by size zeros on MSB side: e.g. 4'b1011 -> 8'b00001011
wire [2*size-1:0] ext_mul_a = {{size{1'b0}}, mul_a};
wire [2*size-1:0] ext_mul_b = {{size{1'b0}}, mul_b};

// Stage 0 registers to synchronize inputs
reg [2*size-1:0] mul_a_reg;
reg [size-1:0]   mul_b_reg;

integer i;

// Partial products generated combinationally using mul_a_reg and mul_b_reg
wire [2*size-1:0] partial_products [0:size-1];

generate
    genvar bit_idx;
    for(bit_idx=0; bit_idx<size; bit_idx=bit_idx+1) begin : gen_partial_products
        assign partial_products[bit_idx] = mul_b_reg[bit_idx] ? (mul_a_reg << bit_idx) : {2*size{1'b0}};
    end
endgenerate

// Pipeline registers for stage 1: sums of partial products pairs
// sum_stage1_0 = partial_products[0] + partial_products[1]
// sum_stage1_1 = partial_products[2] + partial_products[3]
reg [2*size-1:0] sum_stage1_0, sum_stage1_1;

// Pipeline register for stage 2: sum of the two stage 1 sums
reg [2*size-1:0] sum_stage2;

// Sequential logic handling pipeline and reset
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        // Reset all pipeline registers and output
        mul_a_reg    <= 0;
        mul_b_reg    <= 0;
        sum_stage1_0 <= 0;
        sum_stage1_1 <= 0;
        sum_stage2   <= 0;
        mul_out      <= 0;
    end else begin
        // Stage 0: Register inputs
        mul_a_reg <= ext_mul_a;
        mul_b_reg <= mul_b;
        
        // Stage 1: Sum pairs of partial products
        sum_stage1_0 <= partial_products[0] + partial_products[1];
        sum_stage1_1 <= partial_products[2] + partial_products[3];
        
        // Stage 2: Sum of stage 1 sums
        sum_stage2 <= sum_stage1_0 + sum_stage1_1;

        // Output stage: final product output register
        mul_out <= sum_stage2;
    end
end

endmodule