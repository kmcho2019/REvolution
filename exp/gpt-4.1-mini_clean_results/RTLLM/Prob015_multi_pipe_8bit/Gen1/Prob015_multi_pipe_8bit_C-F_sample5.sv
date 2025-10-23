module multi_pipe_8bit (
    input               clk,
    input               rst_n,
    input               mul_en_in,
    input       [7:0]   mul_a,
    input       [7:0]   mul_b,
    output reg          mul_en_out,
    output reg  [15:0]  mul_out
);

    // Pipeline stage enables
    reg mul_en_1, mul_en_2, mul_en_3, mul_en_4;

    // Input registers
    reg [7:0] mul_a_reg;
    reg [7:0] mul_b_reg;

    // Partial product wires: each shifted multiplicand if multiplier bit set, else 0
    wire [15:0] partial_products [7:0];
    genvar i;
    generate
        for (i=0; i<8; i=i+1) begin : gen_partial_products
            assign partial_products[i] = mul_b_reg[i] ? (mul_a_reg << i) : 16'd0;
        end
    endgenerate

    // Stage 2: sum partial products in balanced pairs (4 pairs)
    reg [15:0] sum_0_1, sum_2_3, sum_4_5, sum_6_7;

    // Stage 3: sum of pairs from stage 2 (2 sums)
    reg [15:0] sum_01_23, sum_45_67;

    // Stage 4: final sum
    reg [15:0] mul_out_reg;

    // Stage 1: Register inputs and enable
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

    // Stage 2: sum partial products in pairs, register enable
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_0_1  <= 16'd0;
            sum_2_3  <= 16'd0;
            sum_4_5  <= 16'd0;
            sum_6_7  <= 16'd0;
            mul_en_2 <= 1'b0;
        end else begin
            if (mul_en_1) begin
                sum_0_1 <= partial_products[0] + partial_products[1];
                sum_2_3 <= partial_products[2] + partial_products[3];
                sum_4_5 <= partial_products[4] + partial_products[5];
                sum_6_7 <= partial_products[6] + partial_products[7];
            end else begin
                sum_0_1 <= 16'd0;
                sum_2_3 <= 16'd0;
                sum_4_5 <= 16'd0;
                sum_6_7 <= 16'd0;
            end
            mul_en_2 <= mul_en_1;
        end
    end

    // Stage 3: sum pairs from stage 2, register enable
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_01_23 <= 16'd0;
            sum_45_67 <= 16'd0;
            mul_en_3  <= 1'b0;
        end else begin
            if (mul_en_2) begin
                sum_01_23 <= sum_0_1 + sum_2_3;
                sum_45_67 <= sum_4_5 + sum_6_7;
            end else begin
                sum_01_23 <= 16'd0;
                sum_45_67 <= 16'd0;
            end
            mul_en_3 <= mul_en_2;
        end
    end

    // Stage 4: final sum and output register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out_reg <= 16'd0;
            mul_en_4    <= 1'b0;
        end else begin
            if (mul_en_3) begin
                mul_out_reg <= sum_01_23 + sum_45_67;
            end else begin
                mul_out_reg <= 16'd0;
            end
            mul_en_4 <= mul_en_3;
        end
    end

    // Output assignment with enable gating
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_en_out <= 1'b0;
            mul_out    <= 16'd0;
        end else begin
            mul_en_out <= mul_en_4;
            mul_out    <= mul_en_4 ? mul_out_reg : 16'd0;
        end
    end

endmodule