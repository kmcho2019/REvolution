module multi_pipe_8bit (
    input               clk,
    input               rst_n,
    input               mul_en_in,
    input       [7:0]   mul_a,
    input       [7:0]   mul_b,
    output reg          mul_en_out,
    output reg  [15:0]  mul_out
);

// Pipeline registers for enable signal
reg [3:0] mul_en_pipe;

// Input registers for multiplicand and multiplier
reg [7:0] mul_a_reg;
reg [7:0] mul_b_reg;

// Stage 1: Partial products wires
wire [15:0] partial_products [7:0];

// Generate partial products by AND mul_a with each bit of mul_b
genvar i;
generate
    for (i = 0; i < 8; i = i + 1) begin : gen_partial_products
        assign partial_products[i] = mul_b_reg[i] ? (mul_a_reg << i) : 16'd0;
    end
endgenerate

// Stage 2 registers: sum pairs of partial products
reg [15:0] sum_stage2_0, sum_stage2_1, sum_stage2_2, sum_stage2_3;

// Stage 3 registers: sum pairs of sums from stage 2
reg [15:0] sum_stage3_0, sum_stage3_1;

// Stage 4 register: final sum
reg [15:0] mul_out_reg;

// Pipeline processing
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all pipeline registers
        mul_en_pipe    <= 4'b0;
        mul_a_reg      <= 8'd0;
        mul_b_reg      <= 8'd0;

        sum_stage2_0   <= 16'd0;
        sum_stage2_1   <= 16'd0;
        sum_stage2_2   <= 16'd0;
        sum_stage2_3   <= 16'd0;

        sum_stage3_0   <= 16'd0;
        sum_stage3_1   <= 16'd0;

        mul_out_reg    <= 16'd0;

        mul_en_out     <= 1'b0;
        mul_out        <= 16'd0;
    end else begin
        // Pipeline enable signal shift register
        mul_en_pipe <= {mul_en_pipe[2:0], mul_en_in};
        mul_en_out <= mul_en_pipe[3];

        // Stage 1: register inputs when mul_en_in asserted
        if (mul_en_in) begin
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
        end

        // Stage 2: sum pairs of partial products
        // sum_stage2_0 = partial_products[0] + partial_products[1]
        // sum_stage2_1 = partial_products[2] + partial_products[3]
        // sum_stage2_2 = partial_products[4] + partial_products[5]
        // sum_stage2_3 = partial_products[6] + partial_products[7]
        sum_stage2_0 <= partial_products[0] + partial_products[1];
        sum_stage2_1 <= partial_products[2] + partial_products[3];
        sum_stage2_2 <= partial_products[4] + partial_products[5];
        sum_stage2_3 <= partial_products[6] + partial_products[7];

        // Stage 3: sum pairs of sums from stage 2
        sum_stage3_0 <= sum_stage2_0 + sum_stage2_1;
        sum_stage3_1 <= sum_stage2_2 + sum_stage2_3;

        // Stage 4: final sum
        mul_out_reg <= sum_stage3_0 + sum_stage3_1;

        // Output assignment
        if (mul_en_pipe[3]) begin
            mul_out <= mul_out_reg;
        end else begin
            mul_out <= 16'd0;
        end
    end
end

endmodule