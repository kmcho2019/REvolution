module multi_pipe_8bit (
    input         clk,
    input         rst_n,
    input         mul_en_in,
    input  [7:0]  mul_a,
    input  [7:0]  mul_b,
    output        mul_en_out,
    output [15:0] mul_out
);

// -----------------------------------------------------------------------------
// Input enable pipeline register (1-bit shift register to pipeline mul_en_in)
// We will pipeline the enable signal through 3 stages since the pipeline depth is 3
reg [2:0] mul_en_out_reg;

// Input registers for mul_a and mul_b (sampled only when mul_en_in is high)
reg [7:0] mul_a_reg;
reg [7:0] mul_b_reg;

// Partial products wires: 8 partial products, each 16 bits (shifted left accordingly)
wire [15:0] partial_products [7:0];

genvar i;
generate
    for (i=0; i<8; i=i+1) begin : GEN_PARTIAL_PRODUCTS
        assign partial_products[i] = mul_b_reg[i] ? (mul_a_reg << i) : 16'd0;
    end
endgenerate

// Pipeline registers for partial sum stages
// Stage 1: sum0 = partial_products[0] + partial_products[1]
// Stage 2: sum1 = sum0 + partial_products[2] + partial_products[3]
// Stage 3: sum2 = sum1 + partial_products[4] + partial_products[5] + partial_products[6] + partial_products[7]
reg [15:0] sum_stage1;
reg [15:0] sum_stage2;
reg [15:0] sum_stage3;

// Final product register
reg [15:0] mul_out_reg;

// Pipeline implementation:
// Cycle 0 (input sampling and enable pipeline):
//   - sample mul_a, mul_b, mul_en_in
//   - pipeline mul_en_out_reg <= {mul_en_out_reg[1:0], mul_en_in}
//
// Cycle 1:
//   - compute sum_stage1 = partial_products[0] + partial_products[1]
//
// Cycle 2:
//   - compute sum_stage2 = sum_stage1 + partial_products[2] + partial_products[3]
//
// Cycle 3:
//   - compute sum_stage3 = sum_stage2 + partial_products[4] + partial_products[5] + partial_products[6] + partial_products[7]
//
// Cycle 4:
//   - mul_out_reg <= sum_stage3
//
// After that, mul_en_out_reg[2] is the output enable signal indicating valid mul_out_reg

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mul_en_out_reg <= 3'b000;
        mul_a_reg      <= 8'd0;
        mul_b_reg      <= 8'd0;
        sum_stage1     <= 16'd0;
        sum_stage2     <= 16'd0;
        sum_stage3     <= 16'd0;
        mul_out_reg    <= 16'd0;
    end else begin
        // Pipeline the enable signal
        mul_en_out_reg <= {mul_en_out_reg[1:0], mul_en_in};

        // Sample inputs only when mul_en_in is asserted
        if (mul_en_in) begin
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
        end

        // Stage 1: add partial_products[0] + partial_products[1]
        sum_stage1 <= partial_products[0] + partial_products[1];

        // Stage 2: sum_stage1 + partial_products[2] + partial_products[3]
        sum_stage2 <= sum_stage1 + partial_products[2] + partial_products[3];

        // Stage 3: sum_stage2 + partial_products[4] + partial_products[5] + partial_products[6] + partial_products[7]
        sum_stage3 <= sum_stage2 + partial_products[4] + partial_products[5] + partial_products[6] + partial_products[7];

        // Final product register update
        mul_out_reg <= sum_stage3;
    end
end

// Output signals
assign mul_en_out = mul_en_out_reg[2];
assign mul_out    = mul_en_out ? mul_out_reg : 16'd0;

endmodule