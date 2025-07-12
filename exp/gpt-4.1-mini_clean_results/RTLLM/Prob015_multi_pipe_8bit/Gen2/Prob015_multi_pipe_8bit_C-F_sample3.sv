module multi_pipe_8bit (
    input           clk,
    input           rst_n,
    input           mul_en_in,
    input   [7:0]   mul_a,
    input   [7:0]   mul_b,
    output          mul_en_out,
    output  [15:0]  mul_out
);

    // Pipeline enable shift register (5 bits for input + 4 pipeline stages)
    reg [4:0] mul_en_pipe;

    // Input registers for operands, updated only when mul_en_in is asserted
    reg [7:0] mul_a_reg;
    reg [7:0] mul_b_reg;

    // Generate partial products combinationally
    wire [15:0] partial_products [7:0];
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : gen_partial_products
            assign partial_products[i] = mul_b_reg[i] ? (mul_a_reg << i) : 16'b0;
        end
    endgenerate

    // Pipeline stage 1: sum pairs of partial products (4 sums)
    reg [15:0] sum_0_1, sum_2_3, sum_4_5, sum_6_7;

    // Pipeline stage 2: sum of pairs from stage 1 (2 sums)
    reg [15:0] sum_01_23, sum_45_67;

    // Pipeline stage 3: final sum
    reg [15:0] mul_out_reg;

    // 1) Pipeline enable signal shift register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mul_en_pipe <= 5'b0;
        else
            mul_en_pipe <= {mul_en_pipe[3:0], mul_en_in};
    end

    // 2) Input operand registers capture on mul_en_in
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_a_reg <= 8'b0;
            mul_b_reg <= 8'b0;
        end else if (mul_en_in) begin
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
        end
    end

    // 3) Pipeline Stage 1: sum pairs of partial products
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_0_1 <= 16'b0;
            sum_2_3 <= 16'b0;
            sum_4_5 <= 16'b0;
            sum_6_7 <= 16'b0;
        end else if (mul_en_pipe[1]) begin
            sum_0_1 <= partial_products[0] + partial_products[1];
            sum_2_3 <= partial_products[2] + partial_products[3];
            sum_4_5 <= partial_products[4] + partial_products[5];
            sum_6_7 <= partial_products[6] + partial_products[7];
        end else begin
            sum_0_1 <= 16'b0;
            sum_2_3 <= 16'b0;
            sum_4_5 <= 16'b0;
            sum_6_7 <= 16'b0;
        end
    end

    // 4) Pipeline Stage 2: sum results from stage 1 pairs
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_01_23 <= 16'b0;
            sum_45_67 <= 16'b0;
        end else if (mul_en_pipe[2]) begin
            sum_01_23 <= sum_0_1 + sum_2_3;
            sum_45_67 <= sum_4_5 + sum_6_7;
        end else begin
            sum_01_23 <= 16'b0;
            sum_45_67 <= 16'b0;
        end
    end

    // 5) Pipeline Stage 3: final addition
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mul_out_reg <= 16'b0;
        else if (mul_en_pipe[3])
            mul_out_reg <= sum_01_23 + sum_45_67;
        else
            mul_out_reg <= 16'b0;
    end

    // Output enable assigned from MSB of enable shift register (pipeline stage 4)
    assign mul_en_out = mul_en_pipe[4];

    // Output mux: output valid product only when mul_en_out is asserted
    assign mul_out = mul_en_out ? mul_out_reg : 16'b0;

endmodule