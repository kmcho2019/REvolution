module multi_pipe_8bit (
    input           clk,
    input           rst_n,
    input           mul_en_in,
    input   [7:0]   mul_a,
    input   [7:0]   mul_b,
    output          mul_en_out,
    output  [15:0]  mul_out
);

    // Pipeline registers for enable signal to track pipeline stages (3 stages)
    reg [2:0] mul_en_pipe;

    // Stage 1: Input registers
    reg [7:0] mul_a_reg;
    reg [7:0] mul_b_reg;

    // Partial products (8 partial products)
    wire [15:0] partial_products [7:0];
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : gen_partial_products
            assign partial_products[i] = mul_b_reg[i] ? (mul_a_reg << i) : 16'b0;
        end
    endgenerate

    // Stage 2: sum pairs of partial products (4 sums)
    reg [15:0] sum_stage2[3:0];
    integer j;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (j = 0; j < 4; j = j + 1)
                sum_stage2[j] <= 16'b0;
        end else if (mul_en_pipe[0]) begin
            sum_stage2[0] <= partial_products[0] + partial_products[1];
            sum_stage2[1] <= partial_products[2] + partial_products[3];
            sum_stage2[2] <= partial_products[4] + partial_products[5];
            sum_stage2[3] <= partial_products[6] + partial_products[7];
        end else begin
            for (j = 0; j < 4; j = j + 1)
                sum_stage2[j] <= 16'b0;
        end
    end

    // Stage 3: sum pairs of previous sums (2 sums)
    reg [15:0] sum_stage3[1:0];
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_stage3[0] <= 16'b0;
            sum_stage3[1] <= 16'b0;
        end else if (mul_en_pipe[1]) begin
            sum_stage3[0] <= sum_stage2[0] + sum_stage2[1];
            sum_stage3[1] <= sum_stage2[2] + sum_stage2[3];
        end else begin
            sum_stage3[0] <= 16'b0;
            sum_stage3[1] <= 16'b0;
        end
    end

    // Stage 4: final sum (output product)
    reg [15:0] mul_out_reg;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out_reg <= 16'b0;
        end else if (mul_en_pipe[2]) begin
            mul_out_reg <= sum_stage3[0] + sum_stage3[1];
        end else begin
            mul_out_reg <= 16'b0;
        end
    end

    // Pipeline enable signal shift register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mul_en_pipe <= 3'b0;
        else
            mul_en_pipe <= {mul_en_pipe[1:0], mul_en_in};
    end

    assign mul_en_out = mul_en_pipe[2];

    assign mul_out = mul_en_out ? mul_out_reg : 16'b0;

endmodule