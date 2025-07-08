module multi_pipe_8bit (
    input             clk,
    input             rst_n,
    input             mul_en_in,
    input      [7:0]  mul_a,
    input      [7:0]  mul_b,
    output reg        mul_en_out,
    output reg [15:0] mul_out
);

    // Stage 1 registers: input enable and input data registers
    reg [7:0] mul_a_reg;
    reg [7:0] mul_b_reg;
    reg       mul_en_reg1;

    // Partial products wires for each bit of mul_b
    wire [15:0] partial_products [7:0];

    // Stage 2 registers: sum of partial products in pairs (4 sums)
    reg [15:0] sum_stage2 [3:0];
    reg        mul_en_reg2;

    // Stage 3 registers: sum of pairs from previous sums (2 sums)
    reg [15:0] sum_stage3 [1:0];
    reg        mul_en_reg3;

    // Stage 4 registers: final sum (1 sum)
    reg [15:0] mul_out_reg;
    reg        mul_en_reg4;

    integer i;

    // Generate partial products by ANDing mul_a with each bit of mul_b
    // Each partial product is mul_a shifted left by bit position if bit of mul_b is 1
    // partial_products[i] = mul_b_reg[i] ? (mul_a_reg << i) : 0;
    genvar idx;
    generate
        for (idx = 0; idx < 8; idx = idx + 1) begin : gen_partial_products
            assign partial_products[idx] = mul_b_reg[idx] ? ( {8'b0, mul_a_reg} << idx ) : 16'b0;
        end
    endgenerate

    // Pipeline stage 1: latch inputs and enable
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_a_reg    <= 8'b0;
            mul_b_reg    <= 8'b0;
            mul_en_reg1  <= 1'b0;
        end else begin
            if (mul_en_in) begin
                mul_a_reg   <= mul_a;
                mul_b_reg   <= mul_b;
                mul_en_reg1 <= 1'b1;
            end else begin
                mul_en_reg1 <= 1'b0;
            end
        end
    end

    // Pipeline stage 2: sum partial products in pairs, register enable
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < 4; i = i + 1)
                sum_stage2[i] <= 16'b0;
            mul_en_reg2 <= 1'b0;
        end else begin
            // sum partial_products pairs: (0+1), (2+3), (4+5), (6+7)
            sum_stage2[0] <= partial_products[0] + partial_products[1];
            sum_stage2[1] <= partial_products[2] + partial_products[3];
            sum_stage2[2] <= partial_products[4] + partial_products[5];
            sum_stage2[3] <= partial_products[6] + partial_products[7];
            mul_en_reg2   <= mul_en_reg1;
        end
    end

    // Pipeline stage 3: sum pairs from stage 2, register enable
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_stage3[0] <= 16'b0;
            sum_stage3[1] <= 16'b0;
            mul_en_reg3   <= 1'b0;
        end else begin
            // sum pairs: (0+1), (2+3)
            sum_stage3[0] <= sum_stage2[0] + sum_stage2[1];
            sum_stage3[1] <= sum_stage2[2] + sum_stage2[3];
            mul_en_reg3   <= mul_en_reg2;
        end
    end

    // Pipeline stage 4: final sum and enable register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out_reg  <= 16'b0;
            mul_en_reg4  <= 1'b0;
        end else begin
            mul_out_reg <= sum_stage3[0] + sum_stage3[1];
            mul_en_reg4 <= mul_en_reg3;
        end
    end

    // Output enable and output assignment
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_en_out <= 1'b0;
            mul_out    <= 16'b0;
        end else begin
            mul_en_out <= mul_en_reg4;
            if (mul_en_reg4)
                mul_out <= mul_out_reg;
            else
                mul_out <= 16'b0;
        end
    end

endmodule