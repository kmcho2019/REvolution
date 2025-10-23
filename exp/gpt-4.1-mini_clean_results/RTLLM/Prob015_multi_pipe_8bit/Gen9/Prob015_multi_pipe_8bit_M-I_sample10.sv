module multi_pipe_8bit (
    input           clk,
    input           rst_n,
    input           mul_en_in,
    input   [7:0]   mul_a,
    input   [7:0]   mul_b,
    output          mul_en_out,
    output  [15:0]  mul_out
);

    // Pipeline depth: 4 stages
    // mul_en pipeline shift register to track valid data
    reg [3:0] mul_en_pipe;

    // Stage 1: Input registers
    reg [7:0] mul_a_reg;
    reg [7:0] mul_b_reg;

    // Stage 2: Partial products registers (8 partial products)
    reg [15:0] pp_reg[7:0];

    // Stage 3: Pairwise sums of partial products (8->4)
    reg [15:0] sum2_reg[3:0];

    // Stage 4: Sum final 4 partial sums to product
    reg [15:0] mul_out_reg;

    integer i;

    // Stage 1: Sample inputs and propagate enable
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

    // Stage 2: Generate partial products and register them
    wire [15:0] partial_products[7:0];
    generate
        genvar idx;
        for (idx = 0; idx < 8; idx = idx + 1) begin : gen_partial
            assign partial_products[idx] = mul_b_reg[idx] ? (mul_a_reg << idx) : 16'd0;
        end
    endgenerate

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < 8; i = i + 1) begin
                pp_reg[i] <= 16'd0;
            end
        end else if (mul_en_pipe[0]) begin
            for (i = 0; i < 8; i = i + 1) begin
                pp_reg[i] <= partial_products[i];
            end
        end else begin
            for (i = 0; i < 8; i = i + 1) begin
                pp_reg[i] <= 16'd0;
            end
        end
    end

    // Stage 3: Pairwise sum partial products: 8 -> 4 sums
    // sum2_reg[0] = pp_reg[0] + pp_reg[1]
    // sum2_reg[1] = pp_reg[2] + pp_reg[3]
    // sum2_reg[2] = pp_reg[4] + pp_reg[5]
    // sum2_reg[3] = pp_reg[6] + pp_reg[7]
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < 4; i = i + 1) begin
                sum2_reg[i] <= 16'd0;
            end
        end else if (mul_en_pipe[1]) begin
            sum2_reg[0] <= pp_reg[0] + pp_reg[1];
            sum2_reg[1] <= pp_reg[2] + pp_reg[3];
            sum2_reg[2] <= pp_reg[4] + pp_reg[5];
            sum2_reg[3] <= pp_reg[6] + pp_reg[7];
        end else begin
            for (i = 0; i < 4; i = i + 1) begin
                sum2_reg[i] <= 16'd0;
            end
        end
    end

    // Stage 4: Sum final 4 sums to get product and register output
    // sum_final = sum2_reg[0] + sum2_reg[1] + sum2_reg[2] + sum2_reg[3]
    wire [15:0] sum_final;
    assign sum_final = sum2_reg[0] + sum2_reg[1] + sum2_reg[2] + sum2_reg[3];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out_reg <= 16'd0;
        end else if (mul_en_pipe[2]) begin
            mul_out_reg <= sum_final;
        end else begin
            mul_out_reg <= 16'd0;
        end
    end

    // Output enable is MSB of enable pipeline, valid output after 4 cycles
    assign mul_en_out = mul_en_pipe[3];

    // Output mux, zero when not enabled
    assign mul_out = mul_en_out ? mul_out_reg : 16'd0;

endmodule