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

    // Partial products wires (8 partial products)
    wire [15:0] partial_products [7:0];

    genvar i;
    generate
        for (i = 0; i < 8; i = i +1) begin : gen_partial_products
            assign partial_products[i] = mul_b_reg[i] ? (mul_a_reg << i) : 16'b0;
        end
    endgenerate

    // Stage 1: Pairwise add partial products (4 adders)
    reg [15:0] stage1_sum [3:0];
    reg        stage1_en;

    integer j;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (j=0; j<4; j=j+1)
                stage1_sum[j] <= 16'b0;
            stage1_en <= 1'b0;
        end else if (mul_en_pipe[0]) begin
            stage1_sum[0] <= partial_products[0] + partial_products[1];
            stage1_sum[1] <= partial_products[2] + partial_products[3];
            stage1_sum[2] <= partial_products[4] + partial_products[5];
            stage1_sum[3] <= partial_products[6] + partial_products[7];
            stage1_en <= 1'b1;
        end else begin
            for (j=0; j<4; j=j+1)
                stage1_sum[j] <= 16'b0;
            stage1_en <= 1'b0;
        end
    end

    // Stage 2: Pairwise add stage1 sums (2 adders)
    reg [15:0] stage2_sum [1:0];
    reg        stage2_en;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage2_sum[0] <= 16'b0;
            stage2_sum[1] <= 16'b0;
            stage2_en <= 1'b0;
        end else if (stage1_en) begin
            stage2_sum[0] <= stage1_sum[0] + stage1_sum[1];
            stage2_sum[1] <= stage1_sum[2] + stage1_sum[3];
            stage2_en <= 1'b1;
        end else begin
            stage2_sum[0] <= 16'b0;
            stage2_sum[1] <= 16'b0;
            stage2_en <= 1'b0;
        end
    end

    // Stage 3: Final sum (1 adder)
    reg [15:0] mul_out_reg;
    reg        stage3_en;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out_reg <= 16'b0;
            stage3_en <= 1'b0;
        end else if (stage2_en) begin
            mul_out_reg <= stage2_sum[0] + stage2_sum[1];
            stage3_en <= 1'b1;
        end else begin
            mul_out_reg <= 16'b0;
            stage3_en <= 1'b0;
        end
    end

    // Enable pipeline shifting
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mul_en_pipe <= 4'b0;
        else
            mul_en_pipe <= {mul_en_pipe[2:0], mul_en_in};
    end

    // Sample inputs on mul_en_in active
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_a_reg <= 8'b0;
            mul_b_reg <= 8'b0;
        end else if (mul_en_in) begin
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
        end
    end

    // Output enable is the last stage enable signal
    assign mul_en_out = mul_en_pipe[3];

    // Output product valid only when enable is active
    assign mul_out = mul_en_out ? mul_out_reg : 16'b0;

endmodule