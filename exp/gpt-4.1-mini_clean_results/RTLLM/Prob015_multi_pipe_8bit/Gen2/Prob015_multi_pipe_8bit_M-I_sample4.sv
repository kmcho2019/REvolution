module multi_pipe_8bit (
    input               clk,
    input               rst_n,
    input               mul_en_in,
    input       [7:0]   mul_a,
    input       [7:0]   mul_b,
    output reg          mul_en_out,
    output reg  [15:0]  mul_out
);

    // Stage enables
    reg mul_en_1, mul_en_2, mul_en_3, mul_en_4;

    // Stage 1: Input registers
    reg [7:0] mul_a_reg;
    reg [7:0] mul_b_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_en_1 <= 1'b0;
            mul_a_reg <= 8'd0;
            mul_b_reg <= 8'd0;
        end else begin
            mul_en_1 <= mul_en_in;
            if (mul_en_in) begin
                mul_a_reg <= mul_a;
                mul_b_reg <= mul_b;
            end
        end
    end

    // Stage 2: Partial product generation and registration
    wire [15:0] partial_products [7:0];
    genvar i;
    generate
        for (i=0; i<8; i=i+1) begin : gen_partial_products
            assign partial_products[i] = mul_b_reg[i] ? (mul_a_reg << i) : 16'd0;
        end
    endgenerate

    reg [15:0] pp_reg [7:0];
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            pp_reg[0] <= 16'd0;
            pp_reg[1] <= 16'd0;
            pp_reg[2] <= 16'd0;
            pp_reg[3] <= 16'd0;
            pp_reg[4] <= 16'd0;
            pp_reg[5] <= 16'd0;
            pp_reg[6] <= 16'd0;
            pp_reg[7] <= 16'd0;
            mul_en_2 <= 1'b0;
        end else begin
            if (mul_en_1) begin
                pp_reg[0] <= partial_products[0];
                pp_reg[1] <= partial_products[1];
                pp_reg[2] <= partial_products[2];
                pp_reg[3] <= partial_products[3];
                pp_reg[4] <= partial_products[4];
                pp_reg[5] <= partial_products[5];
                pp_reg[6] <= partial_products[6];
                pp_reg[7] <= partial_products[7];
            end
            // else hold previous to reduce toggling
            mul_en_2 <= mul_en_1;
        end
    end

    // Stage 3: Carry-Save Adder tree to reduce 8 partial products to 2 operands (sum and carry)

    // First CSA layer: 8 inputs to 6 (3 CSAs, each processing 3 inputs to 2 outputs, 2 inputs bypassed)
    // We'll group partial products as (0,1,2), (3,4,5), (6,7)
    // For 6 inputs in 3 CSAs:
    // CSA is: sum = a ^ b ^ c; carry = (a&b) | (b&c) | (a&c) shifted left 1

    function [15:0] csa_sum;
        input [15:0] a, b, c;
        begin
            csa_sum = a ^ b ^ c;
        end
    endfunction

    function [15:0] csa_carry;
        input [15:0] a, b, c;
        begin
            csa_carry = ((a & b) | (b & c) | (a & c)) << 1;
        end
    endfunction

    reg [15:0] sum_0_1_2, carry_0_1_2;
    reg [15:0] sum_3_4_5, carry_3_4_5;
    reg [15:0] sum_6_7, carry_6_7;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_0_1_2 <= 16'd0; carry_0_1_2 <= 16'd0;
            sum_3_4_5 <= 16'd0; carry_3_4_5 <= 16'd0;
            sum_6_7   <= 16'd0; carry_6_7   <= 16'd0;
            mul_en_3  <= 1'b0;
        end else begin
            if (mul_en_2) begin
                // CSA for inputs 0,1,2
                sum_0_1_2  <= csa_sum(pp_reg[0], pp_reg[1], pp_reg[2]);
                carry_0_1_2<= csa_carry(pp_reg[0], pp_reg[1], pp_reg[2]);

                // CSA for inputs 3,4,5
                sum_3_4_5  <= csa_sum(pp_reg[3], pp_reg[4], pp_reg[5]);
                carry_3_4_5<= csa_carry(pp_reg[3], pp_reg[4], pp_reg[5]);

                // CSA for inputs 6,7 (only two inputs, sum is xor, carry is and<<1)
                sum_6_7    <= pp_reg[6] ^ pp_reg[7];
                carry_6_7  <= (pp_reg[6] & pp_reg[7]) << 1;
            end
            // else hold previous
            mul_en_3 <= mul_en_2;
        end
    end

    // Stage 4: Final CSA layer: add the six operands (sum and carry from stage 3) into two operands

    // Inputs: sum_0_1_2, carry_0_1_2, sum_3_4_5, carry_3_4_5, sum_6_7, carry_6_7
    // We'll group as (sum_0_1_2, carry_0_1_2, sum_3_4_5) and (carry_3_4_5, sum_6_7, carry_6_7)

    reg [15:0] sum_low, carry_low;
    reg [15:0] sum_high, carry_high;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_low   <= 16'd0; carry_low   <= 16'd0;
            sum_high  <= 16'd0; carry_high  <= 16'd0;
            mul_en_4  <= 1'b0;
        end else begin
            if (mul_en_3) begin
                sum_low   <= csa_sum(sum_0_1_2, carry_0_1_2, sum_3_4_5);
                carry_low <= csa_carry(sum_0_1_2, carry_0_1_2, sum_3_4_5);

                sum_high  <= csa_sum(carry_3_4_5, sum_6_7, carry_6_7);
                carry_high<= csa_carry(carry_3_4_5, sum_6_7, carry_6_7);
            end
            // else hold previous
            mul_en_4 <= mul_en_3;
        end
    end

    // Stage 5: Final addition (carry propagate adder) of sum_low + carry_low + sum_high + carry_high

    reg [15:0] mul_out_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out_reg <= 16'd0;
        end else begin
            if (mul_en_4) begin
                // sum all four operands
                mul_out_reg <= sum_low + carry_low + sum_high + carry_high;
            end
            // else hold previous (or reset to 0?)
            else
                mul_out_reg <= 16'd0;
        end
    end

    // Output register and enable assignment
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_en_out <= 1'b0;
            mul_out <= 16'd0;
        end else begin
            mul_en_out <= mul_en_4;
            mul_out <= mul_en_4 ? mul_out_reg : 16'd0;
        end
    end

endmodule