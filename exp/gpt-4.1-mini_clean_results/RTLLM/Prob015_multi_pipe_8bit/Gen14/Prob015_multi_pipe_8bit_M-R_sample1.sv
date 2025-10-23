module multi_pipe_8bit (
    input              clk,
    input              rst_n,
    input              mul_en_in,
    input      [7:0]   mul_a,
    input      [7:0]   mul_b,
    output reg         mul_en_out,
    output reg [15:0]  mul_out
);

// Stage 1 registers: inputs and enable
reg [7:0] mul_a_reg;
reg [7:0] mul_b_reg;
reg       mul_en_reg1;

// Partial products wires (combinational, generated from stage 1 regs)
wire [15:0] partial_products[7:0];
genvar i;
generate
    for (i = 0; i < 8; i = i + 1) begin : gen_partial_products
        assign partial_products[i] = (mul_en_reg1 && mul_b_reg[i]) ? (mul_a_reg << i) : 16'd0;
    end
endgenerate

// Stage 2 registers: partial sums and enable
reg [15:0] sum_stage2_0;
reg [15:0] sum_stage2_1;
reg [15:0] sum_stage2_2;
reg [15:0] sum_stage2_3;
reg        mul_en_reg2;

// Stage 3 registers: final product and enable
reg [15:0] product_reg;
reg        mul_en_reg3;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_a_reg     <= 8'd0;
        mul_b_reg     <= 8'd0;
        mul_en_reg1   <= 1'b0;

        sum_stage2_0  <= 16'd0;
        sum_stage2_1  <= 16'd0;
        sum_stage2_2  <= 16'd0;
        sum_stage2_3  <= 16'd0;
        mul_en_reg2   <= 1'b0;

        product_reg   <= 16'd0;
        mul_en_reg3   <= 1'b0;

        mul_en_out    <= 1'b0;
        mul_out       <= 16'd0;
    end else begin
        // Stage 1: Capture inputs and enable
        mul_en_reg1 <= mul_en_in;
        if (mul_en_in) begin
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
        end

        // Stage 2: Register partial sums of pairs of partial products
        // Group partial products pairwise to reduce combinational adder size
        sum_stage2_0 <= partial_products[0] + partial_products[1];
        sum_stage2_1 <= partial_products[2] + partial_products[3];
        sum_stage2_2 <= partial_products[4] + partial_products[5];
        sum_stage2_3 <= partial_products[6] + partial_products[7];
        mul_en_reg2  <= mul_en_reg1;

        // Stage 3: Sum stage2 partial sums pairwise to get final product
        product_reg  <= (sum_stage2_0 + sum_stage2_1) + (sum_stage2_2 + sum_stage2_3);
        mul_en_reg3  <= mul_en_reg2;

        // Output registers
        mul_en_out <= mul_en_reg3;
        mul_out    <= mul_en_reg3 ? product_reg : 16'd0;
    end
end

endmodule