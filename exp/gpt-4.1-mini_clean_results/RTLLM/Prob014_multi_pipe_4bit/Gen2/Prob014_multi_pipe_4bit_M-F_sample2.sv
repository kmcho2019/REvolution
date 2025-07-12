module multi_pipe_4bit #(parameter size = 4)(
    input                   clk,
    input                   rst_n,
    input      [size-1:0]   mul_a,
    input      [size-1:0]   mul_b,
    output reg [2*size-1:0] mul_out
);

// Extend inputs by size zeros on MSB side: e.g. 4'b1011 -> 8'b00001011
wire [2*size-1:0] ext_mul_a = {{size{1'b0}}, mul_a};

// Stage 0 registers: register extended multiplicand and multiplier
reg [2*size-1:0] mul_a_reg;
reg [size-1:0]   mul_b_reg;

// Stage 1 registers: sums of partial products pairs
reg [2*size-1:0] sum_stage1_0_reg;
reg [2*size-1:0] sum_stage1_1_reg;

// Stage 2 register: final sum of stage1 sums
reg [2*size-1:0] mul_out_reg;

// Partial products combinational generation from stage0 registers
wire [2*size-1:0] partial_products [0:size-1];
genvar i;
generate
    for(i=0; i<size; i=i+1) begin : gen_partial_products
        assign partial_products[i] = mul_b_reg[i] ? (mul_a_reg << i) : {2*size{1'b0}};
    end
endgenerate

// Sum partial products in pairs combinationally for stage 1 inputs
wire [2*size-1:0] sum_stage1_0 = partial_products[0] + partial_products[1];
wire [2*size-1:0] sum_stage1_1 = partial_products[2] + partial_products[3];

// Stage 2 sum combinationally from stage1 registers
wire [2*size-1:0] sum_stage2 = sum_stage1_0_reg + sum_stage1_1_reg;

// Pipeline sequential logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_a_reg       <= 0;
        mul_b_reg       <= 0;
        sum_stage1_0_reg <= 0;
        sum_stage1_1_reg <= 0;
        mul_out_reg     <= 0;
        mul_out         <= 0;
    end else begin
        // Stage 0: register inputs
        mul_a_reg <= ext_mul_a;
        mul_b_reg <= mul_b;

        // Stage 1: register sums of partial products
        sum_stage1_0_reg <= sum_stage1_0;
        sum_stage1_1_reg <= sum_stage1_1;

        // Stage 2: register final sum
        mul_out_reg <= sum_stage2;

        // Output register updated from stage 2 register
        mul_out <= mul_out_reg;
    end
end

endmodule