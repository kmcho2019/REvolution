module multi_pipe_8bit (
    input           clk,
    input           rst_n,
    input           mul_en_in,
    input   [7:0]   mul_a,
    input   [7:0]   mul_b,
    output          mul_en_out,
    output  [15:0]  mul_out
);

    // Enable pipeline shift register (4 stages)
    reg [3:0] mul_en_pipe;

    // Stage 1: Input registers (sampled on mul_en_in)
    reg [7:0] mul_a_reg;
    reg [7:0] mul_b_reg;

    // Stage 2: Partial products wires (generated from registered inputs)
    wire [15:0] partial_products[7:0];
    genvar i;
    generate
        for (i=0; i<8; i=i+1) begin : gen_partial_products
            assign partial_products[i] = mul_b_reg[i] ? (mul_a_reg << i) : 16'd0;
        end
    endgenerate

    // Stage 2: Intermediate sums registers (sum pairs of partial products)
    // 8 partial products -> 4 sums
    reg [15:0] sum_stage2 [3:0];

    // Stage 3: Final sums registers (sum pairs of Stage 2 sums)
    // 4 sums -> 2 sums
    reg [15:0] sum_stage3 [1:0];

    // Stage 4: Final product register (sum of Stage 3 sums)
    reg [15:0] mul_out_reg;

    integer idx;

    // Enable pipeline shift register logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mul_en_pipe <= 4'b0;
        else
            mul_en_pipe <= {mul_en_pipe[2:0], mul_en_in};
    end

    // Stage 1: Register inputs on mul_en_in
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_a_reg <= 8'd0;
            mul_b_reg <= 8'd0;
        end else if (mul_en_in) begin
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
        end
    end

    // Stage 2: Sum pairs of partial products into sum_stage2 registers when mul_en_pipe[1] is active
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (idx = 0; idx < 4; idx = idx + 1) begin
                sum_stage2[idx] <= 16'd0;
            end
        end else if (mul_en_pipe[1]) begin
            sum_stage2[0] <= partial_products[0] + partial_products[1];
            sum_stage2[1] <= partial_products[2] + partial_products[3];
            sum_stage2[2] <= partial_products[4] + partial_products[5];
            sum_stage2[3] <= partial_products[6] + partial_products[7];
        end else begin
            for (idx = 0; idx < 4; idx = idx + 1) begin
                sum_stage2[idx] <= 16'd0;
            end
        end
    end

    // Stage 3: Sum pairs of sum_stage2 into sum_stage3 registers when mul_en_pipe[2] is active
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_stage3[0] <= 16'd0;
            sum_stage3[1] <= 16'd0;
        end else if (mul_en_pipe[2]) begin
            sum_stage3[0] <= sum_stage2[0] + sum_stage2[1];
            sum_stage3[1] <= sum_stage2[2] + sum_stage2[3];
        end else begin
            sum_stage3[0] <= 16'd0;
            sum_stage3[1] <= 16'd0;
        end
    end

    // Stage 4: Final sum of sum_stage3 to get final product when mul_en_pipe[3] is active
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out_reg <= 16'd0;
        end else if (mul_en_pipe[3]) begin
            mul_out_reg <= sum_stage3[0] + sum_stage3[1];
        end else begin
            mul_out_reg <= 16'd0;
        end
    end

    // Output enable signal is MSB of enable pipeline shift register
    assign mul_en_out = mul_en_pipe[3];

    // Output product is valid only when mul_en_out is active
    assign mul_out = mul_en_out ? mul_out_reg : 16'd0;

endmodule