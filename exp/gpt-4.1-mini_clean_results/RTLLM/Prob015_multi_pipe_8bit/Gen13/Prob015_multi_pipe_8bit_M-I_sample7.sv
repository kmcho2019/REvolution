module multi_pipe_8bit (
    input           clk,
    input           rst_n,
    input           mul_en_in,
    input   [7:0]   mul_a,
    input   [7:0]   mul_b,
    output          mul_en_out,
    output  [15:0]  mul_out
);

    // Pipeline enable shift register (5 stages for 4 addition stages + input sampling)
    reg [4:0] mul_en_pipe;

    // Stage 0: Input registers (sample inputs on mul_en_in)
    reg [7:0] mul_a_reg;
    reg [7:0] mul_b_reg;

    // Stage 1: Partial products registers (8 x 16-bit)
    reg [15:0] pp_reg [7:0];

    // Stage 2: Sum pairs of partial products (4 x 16-bit registers)
    reg [15:0] sum2_reg [3:0];

    // Stage 3: Sum pairs of sums from Stage 2 (2 x 16-bit registers)
    reg [15:0] sum3_reg [1:0];

    // Stage 4: Final sum register (product output)
    reg [15:0] mul_out_reg;

    integer i;

    // 1) Shift mul_en_in through pipeline stages
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mul_en_pipe <= 5'b0;
        else
            mul_en_pipe <= {mul_en_pipe[3:0], mul_en_in};
    end

    // 2) Sample inputs when mul_en_in asserted
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_a_reg <= 8'b0;
            mul_b_reg <= 8'b0;
        end else if (mul_en_in) begin
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
        end
    end

    // 3) Generate partial products combinationally
    wire [15:0] partial_products [7:0];
    genvar gi;
    generate
        for (gi = 0; gi < 8; gi = gi + 1) begin : gen_partial_products
            assign partial_products[gi] = mul_b_reg[gi] ? (mul_a_reg << gi) : 16'b0;
        end
    endgenerate

    // 4) Register partial products on Stage 1 when mul_en_pipe[0] (input sampled)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i=0; i<8; i=i+1)
                pp_reg[i] <= 16'b0;
        end else if (mul_en_pipe[0]) begin
            for (i=0; i<8; i=i+1)
                pp_reg[i] <= partial_products[i];
        end else begin
            for (i=0; i<8; i=i+1)
                pp_reg[i] <= 16'b0;
        end
    end

    // 5) Stage 2: Add partial products pairwise (pp_reg[0]+pp_reg[1], pp_reg[2]+pp_reg[3], etc.)
    // Register sums when mul_en_pipe[1] asserted
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i=0; i<4; i=i+1)
                sum2_reg[i] <= 16'b0;
        end else if (mul_en_pipe[1]) begin
            sum2_reg[0] <= pp_reg[0] + pp_reg[1];
            sum2_reg[1] <= pp_reg[2] + pp_reg[3];
            sum2_reg[2] <= pp_reg[4] + pp_reg[5];
            sum2_reg[3] <= pp_reg[6] + pp_reg[7];
        end else begin
            for (i=0; i<4; i=i+1)
                sum2_reg[i] <= 16'b0;
        end
    end

    // 6) Stage 3: Add sums from Stage 2 pairwise
    // Register sums when mul_en_pipe[2] asserted
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum3_reg[0] <= 16'b0;
            sum3_reg[1] <= 16'b0;
        end else if (mul_en_pipe[2]) begin
            sum3_reg[0] <= sum2_reg[0] + sum2_reg[1];
            sum3_reg[1] <= sum2_reg[2] + sum2_reg[3];
        end else begin
            sum3_reg[0] <= 16'b0;
            sum3_reg[1] <= 16'b0;
        end
    end

    // 7) Stage 4: Add final two sums to get product
    // Register final product when mul_en_pipe[3] asserted
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mul_out_reg <= 16'b0;
        else if (mul_en_pipe[3])
            mul_out_reg <= sum3_reg[0] + sum3_reg[1];
        else
            mul_out_reg <= 16'b0;
    end

    // Output enable is mul_en_pipe[4] (aligned to final output)
    assign mul_en_out = mul_en_pipe[4];

    // Output product valid only when output enable asserted; otherwise 0
    assign mul_out = mul_en_out ? mul_out_reg : 16'b0;

endmodule