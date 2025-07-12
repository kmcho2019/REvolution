module multi_pipe_8bit (
    input           clk,
    input           rst_n,
    input           mul_en_in,
    input   [7:0]   mul_a,
    input   [7:0]   mul_b,
    output          mul_en_out,
    output  [15:0]  mul_out
);

    // Pipeline register to track enable signal through 4 pipeline stages
    reg [3:0] mul_en_pipe;

    // Stage 1 registers: latch inputs when mul_en_in is high
    reg [7:0] mul_a_reg;
    reg [7:0] mul_b_reg;

    // Partial products wires (16-bit each)
    wire [15:0] partial_products [7:0];
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : gen_partial_products
            assign partial_products[i] = mul_b_reg[i] ? (mul_a_reg << i) : 16'b0;
        end
    endgenerate

    // Stage 2: first level addition - sum pairs of partial products
    wire [15:0] sum_pair_0 = partial_products[0] + partial_products[1];
    wire [15:0] sum_pair_1 = partial_products[2] + partial_products[3];
    wire [15:0] sum_pair_2 = partial_products[4] + partial_products[5];
    wire [15:0] sum_pair_3 = partial_products[6] + partial_products[7];

    // Stage 2 registers: register sums and enable signal
    reg [15:0] sum_pair_0_reg, sum_pair_1_reg, sum_pair_2_reg, sum_pair_3_reg;

    // Stage 3: second level addition - sum pairs of registered sums from stage 2
    wire [15:0] sum_quad_0 = sum_pair_0_reg + sum_pair_1_reg;
    wire [15:0] sum_quad_1 = sum_pair_2_reg + sum_pair_3_reg;

    // Stage 3 registers: register sums and enable signal
    reg [15:0] sum_quad_0_reg, sum_quad_1_reg;

    // Stage 4: final addition stage - sum final registered sums
    reg [15:0] mul_out_reg;

    // Pipeline enable shift register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mul_en_pipe <= 4'b0;
        else
            mul_en_pipe <= {mul_en_pipe[2:0], mul_en_in};
    end

    // Stage 1: register inputs on mul_en_in
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_a_reg <= 8'b0;
            mul_b_reg <= 8'b0;
        end else if (mul_en_in) begin
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
        end
    end

    // Stage 2: register first level sums on mul_en_pipe[0]
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_pair_0_reg <= 16'b0;
            sum_pair_1_reg <= 16'b0;
            sum_pair_2_reg <= 16'b0;
            sum_pair_3_reg <= 16'b0;
        end else if (mul_en_pipe[0]) begin
            sum_pair_0_reg <= sum_pair_0;
            sum_pair_1_reg <= sum_pair_1;
            sum_pair_2_reg <= sum_pair_2;
            sum_pair_3_reg <= sum_pair_3;
        end else begin
            sum_pair_0_reg <= 16'b0;
            sum_pair_1_reg <= 16'b0;
            sum_pair_2_reg <= 16'b0;
            sum_pair_3_reg <= 16'b0;
        end
    end

    // Stage 3: register second level sums on mul_en_pipe[1]
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_quad_0_reg <= 16'b0;
            sum_quad_1_reg <= 16'b0;
        end else if (mul_en_pipe[1]) begin
            sum_quad_0_reg <= sum_quad_0;
            sum_quad_1_reg <= sum_quad_1;
        end else begin
            sum_quad_0_reg <= 16'b0;
            sum_quad_1_reg <= 16'b0;
        end
    end

    // Stage 4: final product register on mul_en_pipe[2]
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mul_out_reg <= 16'b0;
        else if (mul_en_pipe[2])
            mul_out_reg <= sum_quad_0_reg + sum_quad_1_reg;
        else
            mul_out_reg <= 16'b0;
    end

    // Output enable from MSB of mul_en_pipe
    assign mul_en_out = mul_en_pipe[3];

    // Output product valid only when mul_en_out is high
    assign mul_out = mul_en_out ? mul_out_reg : 16'b0;

endmodule