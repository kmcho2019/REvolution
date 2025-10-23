module multi_pipe_8bit (
    input           clk,
    input           rst_n,
    input           mul_en_in,
    input   [7:0]   mul_a,
    input   [7:0]   mul_b,
    output          mul_en_out,
    output  [15:0]  mul_out
);

    // Pipeline enable shift register (3 stages) to track validity
    reg [2:0] mul_en_pipe;

    // Stage 1: Input registers
    reg [7:0] mul_a_reg;
    reg [7:0] mul_b_reg;

    // Partial products wires (16-bit each)
    wire [15:0] partial_products [7:0];
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : gen_partial_products
            // Generate partial product only if mul_en_pipe[0] is set (inputs valid)
            assign partial_products[i] = mul_en_pipe[0] && mul_b_reg[i] ? (mul_a_reg << i) : 16'd0;
        end
    endgenerate

    // Stage 2 partial sums (first level of addition tree)
    // Sum pairs: (0+1), (2+3), (4+5), (6+7)
    reg [15:0] sum_stage1 [3:0];
    // Stage 3 partial sums (second level)
    // Sum pairs: (sum_stage1[0] + sum_stage1[1]), (sum_stage1[2] + sum_stage1[3])
    reg [15:0] sum_stage2 [1:0];
    // Stage 4 final sum
    reg [15:0] mul_out_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_en_pipe <= 3'b0;
            mul_a_reg   <= 8'd0;
            mul_b_reg   <= 8'd0;
            sum_stage1[0] <= 16'd0;
            sum_stage1[1] <= 16'd0;
            sum_stage1[2] <= 16'd0;
            sum_stage1[3] <= 16'd0;
            sum_stage2[0] <= 16'd0;
            sum_stage2[1] <= 16'd0;
            mul_out_reg   <= 16'd0;
        end else begin
            // Shift in mul_en_in to track pipeline validity
            mul_en_pipe <= {mul_en_pipe[1:0], mul_en_in};

            // Stage 1 input registers updated only when mul_en_in is high
            if (mul_en_in) begin
                mul_a_reg <= mul_a;
                mul_b_reg <= mul_b;
            end

            // Stage 2 sum partial products (first addition stage)
            // only when stage 1 is valid (mul_en_pipe[0] == 1)
            if (mul_en_pipe[0]) begin
                sum_stage1[0] <= partial_products[0] + partial_products[1];
                sum_stage1[1] <= partial_products[2] + partial_products[3];
                sum_stage1[2] <= partial_products[4] + partial_products[5];
                sum_stage1[3] <= partial_products[6] + partial_products[7];
            end else begin
                sum_stage1[0] <= 16'd0;
                sum_stage1[1] <= 16'd0;
                sum_stage1[2] <= 16'd0;
                sum_stage1[3] <= 16'd0;
            end

            // Stage 3 sum pairs of sum_stage1 (second addition stage)
            // valid when mul_en_pipe[1] == 1
            if (mul_en_pipe[1]) begin
                sum_stage2[0] <= sum_stage1[0] + sum_stage1[1];
                sum_stage2[1] <= sum_stage1[2] + sum_stage1[3];
            end else begin
                sum_stage2[0] <= 16'd0;
                sum_stage2[1] <= 16'd0;
            end

            // Stage 4 final sum register (output product)
            // valid when mul_en_pipe[2] == 1
            if (mul_en_pipe[2]) begin
                mul_out_reg <= sum_stage2[0] + sum_stage2[1];
            end else begin
                mul_out_reg <= 16'd0;
            end
        end
    end

    // Output enable from MSB of enable pipeline
    assign mul_en_out = mul_en_pipe[2];

    // Output product valid only when mul_en_out is high
    assign mul_out = mul_en_out ? mul_out_reg : 16'd0;

endmodule