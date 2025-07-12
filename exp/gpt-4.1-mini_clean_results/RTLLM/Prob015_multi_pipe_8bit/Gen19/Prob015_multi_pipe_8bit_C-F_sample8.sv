module multi_pipe_8bit (
    input           clk,
    input           rst_n,
    input           mul_en_in,
    input   [7:0]   mul_a,
    input   [7:0]   mul_b,
    output          mul_en_out,
    output  [15:0]  mul_out
);

    // Enable pipeline shift register (3 stages)
    reg [2:0] mul_en_pipe;

    // Input operand registers
    reg [7:0] mul_a_reg;
    reg [7:0] mul_b_reg;

    // Partial products wires (8 partial products)
    wire [15:0] partial_products [7:0];

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : gen_partial_products
            assign partial_products[i] = mul_b_reg[i] ? (mul_a_reg << i) : 16'd0;
        end
    endgenerate

    // First stage of addition: pairwise sums (4 sums)
    wire [15:0] sum_stage1 [3:0];
    assign sum_stage1[0] = partial_products[0] + partial_products[1];
    assign sum_stage1[1] = partial_products[2] + partial_products[3];
    assign sum_stage1[2] = partial_products[4] + partial_products[5];
    assign sum_stage1[3] = partial_products[6] + partial_products[7];

    // Second stage of addition: sum pairs from stage 1 (2 sums)
    wire [15:0] sum_stage2 [1:0];
    assign sum_stage2[0] = sum_stage1[0] + sum_stage1[1];
    assign sum_stage2[1] = sum_stage1[2] + sum_stage1[3];

    // Final sum (combinational)
    wire [15:0] final_sum;
    assign final_sum = sum_stage2[0] + sum_stage2[1];

    // Output product register
    reg [15:0] mul_out_reg;

    // 1) Enable pipeline shift register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mul_en_pipe <= 3'b0;
        else
            mul_en_pipe <= {mul_en_pipe[1:0], mul_en_in};
    end

    // 2) Input registers sampled on mul_en_in
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_a_reg <= 8'b0;
            mul_b_reg <= 8'b0;
        end else if (mul_en_in) begin
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
        end
    end

    // 3) Output register updated with final sum when mul_en_pipe[1] is high
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mul_out_reg <= 16'b0;
        else if (mul_en_pipe[1])
            mul_out_reg <= final_sum;
        else
            mul_out_reg <= 16'b0;
    end

    // Output enable from MSB of pipeline shift register
    assign mul_en_out = mul_en_pipe[2];

    // Output product valid only when mul_en_out is active
    assign mul_out = mul_en_out ? mul_out_reg : 16'b0;

endmodule