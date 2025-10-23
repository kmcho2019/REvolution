module multi_pipe_8bit (
    input           clk,
    input           rst_n,
    input           mul_en_in,
    input   [7:0]   mul_a,
    input   [7:0]   mul_b,
    output          mul_en_out,
    output  [15:0]  mul_out
);

    // Pipeline register for enable signal (4 stages due to two-stage addition pipeline)
    reg [3:0] mul_en_pipe;

    // Input operand registers
    reg [7:0] mul_a_reg;
    reg [7:0] mul_b_reg;

    // Partial products (8 partial products, each 16-bit)
    wire [15:0] partial_products [7:0];

    genvar i;
    generate
        for (i = 0; i < 8; i=i+1) begin : gen_pp
            assign partial_products[i] = mul_b_reg[i] ? (mul_a_reg << i) : 16'd0;
        end
    endgenerate

    // Stage 1 registers - sum pairs of partial products
    reg [15:0] sum_stage1 [3:0];

    // Stage 2 registers - sum results of stage 1
    reg [15:0] sum_stage2 [1:0];

    // Final product register
    reg [15:0] mul_out_reg;

    integer j;

    // Input register stage and enable pipeline
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_en_pipe <= 4'b0;
            mul_a_reg <= 8'd0;
            mul_b_reg <= 8'd0;
        end else begin
            mul_en_pipe <= {mul_en_pipe[2:0], mul_en_in};
            if (mul_en_in) begin
                mul_a_reg <= mul_a;
                mul_b_reg <= mul_b;
            end
        end
    end

    // Stage 1: sum pairs of partial products
    // When enable stage 1 is active, latch sums, else clear
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (j=0; j<4; j=j+1) begin
                sum_stage1[j] <= 16'd0;
            end
        end else if (mul_en_pipe[1]) begin
            sum_stage1[0] <= partial_products[0] + partial_products[1];
            sum_stage1[1] <= partial_products[2] + partial_products[3];
            sum_stage1[2] <= partial_products[4] + partial_products[5];
            sum_stage1[3] <= partial_products[6] + partial_products[7];
        end else begin
            for (j=0; j<4; j=j+1) begin
                sum_stage1[j] <= 16'd0;
            end
        end
    end

    // Stage 2: sum pairs of stage 1 results
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_stage2[0] <= 16'd0;
            sum_stage2[1] <= 16'd0;
        end else if (mul_en_pipe[2]) begin
            sum_stage2[0] <= sum_stage1[0] + sum_stage1[1];
            sum_stage2[1] <= sum_stage1[2] + sum_stage1[3];
        end else begin
            sum_stage2[0] <= 16'd0;
            sum_stage2[1] <= 16'd0;
        end
    end

    // Stage 3: final product sum and output register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out_reg <= 16'd0;
        end else if (mul_en_pipe[3]) begin
            mul_out_reg <= sum_stage2[0] + sum_stage2[1];
        end else begin
            mul_out_reg <= 16'd0;
        end
    end

    // Output enable aligned with final product valid
    assign mul_en_out = mul_en_pipe[3];

    // Output mux
    assign mul_out = mul_en_out ? mul_out_reg : 16'd0;

endmodule