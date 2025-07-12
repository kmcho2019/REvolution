module multi_pipe_8bit (
    input           clk,
    input           rst_n,
    input           mul_en_in,
    input   [7:0]   mul_a,
    input   [7:0]   mul_b,
    output          mul_en_out,
    output  [15:0]  mul_out
);

    // Pipeline enable shift register (5 bits: input enable + 4 pipeline stages)
    reg [4:0] mul_en_pipe;

    // Input operand registers, sampled only when mul_en_in is asserted
    reg [7:0] mul_a_reg;
    reg [7:0] mul_b_reg;

    // Partial products wires
    wire [15:0] partial_products [7:0];
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : gen_partial_products
            assign partial_products[i] = mul_b_reg[i] ? (mul_a_reg << i) : 16'b0;
        end
    endgenerate

    // Pipeline stage 1: sum of partial products in groups of three and one group of two
    reg [15:0] sum_0_2; // sum of partial_products[0] + [1] + [2]
    reg [15:0] sum_3_5; // sum of partial_products[3] + [4] + [5]
    reg [15:0] sum_6_7; // sum of partial_products[6] + [7]

    // Pipeline stage 2: sum of stage 1 outputs
    reg [15:0] sum_0_5; // sum of sum_0_2 + sum_3_5
    reg [15:0] sum_6_7_reg; // registered sum_6_7 for timing balance

    // Pipeline stage 3: final product sum
    reg [15:0] mul_out_reg;

    // 1) Pipeline enable shift register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mul_en_pipe <= 5'b0;
        else
            mul_en_pipe <= {mul_en_pipe[3:0], mul_en_in};
    end

    // 2) Input registers: sample inputs only when mul_en_in asserted
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_a_reg <= 8'b0;
            mul_b_reg <= 8'b0;
        end else if (mul_en_in) begin
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
        end
    end

    // 3) Pipeline Stage 1: sum partial products groups
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_0_2 <= 16'b0;
            sum_3_5 <= 16'b0;
            sum_6_7 <= 16'b0;
        end else if (mul_en_pipe[1]) begin
            sum_0_2 <= partial_products[0] + partial_products[1] + partial_products[2];
            sum_3_5 <= partial_products[3] + partial_products[4] + partial_products[5];
            sum_6_7 <= partial_products[6] + partial_products[7];
        end else begin
            sum_0_2 <= 16'b0;
            sum_3_5 <= 16'b0;
            sum_6_7 <= 16'b0;
        end
    end

    // 4) Pipeline Stage 2: sum pairs from stage 1
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_0_5 <= 16'b0;
            sum_6_7_reg <= 16'b0;
        end else if (mul_en_pipe[2]) begin
            sum_0_5 <= sum_0_2 + sum_3_5;
            sum_6_7_reg <= sum_6_7;
        end else begin
            sum_0_5 <= 16'b0;
            sum_6_7_reg <= 16'b0;
        end
    end

    // 5) Pipeline Stage 3: final sum to produce product
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mul_out_reg <= 16'b0;
        else if (mul_en_pipe[3])
            mul_out_reg <= sum_0_5 + sum_6_7_reg;
        else
            mul_out_reg <= 16'b0;
    end

    // Output enable signal from MSB of enable pipeline (5th stage)
    assign mul_en_out = mul_en_pipe[4];

    // Output product is valid only when mul_en_out is asserted, else zero
    assign mul_out = mul_en_out ? mul_out_reg : 16'b0;

endmodule