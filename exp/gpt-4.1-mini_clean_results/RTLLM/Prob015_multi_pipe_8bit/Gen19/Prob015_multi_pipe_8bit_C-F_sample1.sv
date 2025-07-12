module multi_pipe_8bit (
    input           clk,
    input           rst_n,
    input           mul_en_in,
    input   [7:0]   mul_a,
    input   [7:0]   mul_b,
    output          mul_en_out,
    output  [15:0]  mul_out
);

    // Pipeline enable shift register (4 stages)
    reg [3:0] mul_en_pipe;

    // Stage 0: Input registers
    reg [7:0] mul_a_reg;
    reg [7:0] mul_b_reg;

    // Stage 1: Partial products generation (wires combinational from Stage 0 regs)
    wire [15:0] partial_products [7:0];
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : gen_partial_products
            assign partial_products[i] = mul_b_reg[i] ? (mul_a_reg << i) : 16'd0;
        end
    endgenerate

    // Stage 2 registers: Partial sums of pairs (reduce 8 partial products to 4 sums)
    reg [15:0] sum_pairs [3:0];
    integer j;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (j = 0; j < 4; j = j + 1)
                sum_pairs[j] <= 16'd0;
        end else if (mul_en_pipe[1]) begin
            sum_pairs[0] <= partial_products[0] + partial_products[1];
            sum_pairs[1] <= partial_products[2] + partial_products[3];
            sum_pairs[2] <= partial_products[4] + partial_products[5];
            sum_pairs[3] <= partial_products[6] + partial_products[7];
        end else begin
            for (j = 0; j < 4; j = j + 1)
                sum_pairs[j] <= 16'd0;
        end
    end

    // Stage 3 registers: Final sum of the 4 intermediate sums (reduce 4 sums to 1 product)
    reg [15:0] final_sum;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            final_sum <= 16'd0;
        end else if (mul_en_pipe[2]) begin
            final_sum <= sum_pairs[0] + sum_pairs[1] + sum_pairs[2] + sum_pairs[3];
        end else begin
            final_sum <= 16'd0;
        end
    end

    // Update mul_en pipeline on each clock
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mul_en_pipe <= 4'b0;
        else
            mul_en_pipe <= {mul_en_pipe[2:0], mul_en_in};
    end

    // Input registers update on mul_en_in
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_a_reg <= 8'd0;
            mul_b_reg <= 8'd0;
        end else if (mul_en_in) begin
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
        end
    end

    // Output enable signal from pipeline MSB (stage 3)
    assign mul_en_out = mul_en_pipe[3];

    // Output product assigned only when mul_en_out active; else zero
    assign mul_out = mul_en_out ? final_sum : 16'd0;

endmodule