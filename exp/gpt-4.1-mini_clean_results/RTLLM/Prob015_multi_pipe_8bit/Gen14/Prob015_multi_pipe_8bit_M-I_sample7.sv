module multi_pipe_8bit (
    input           clk,
    input           rst_n,
    input           mul_en_in,
    input   [7:0]   mul_a,
    input   [7:0]   mul_b,
    output reg      mul_en_out,
    output reg [15:0] mul_out
);

    // Pipeline register for mul_en_in signal propagation (5 stages)
    reg [4:0] mul_en_pipe;

    // Input registers for multiplicand and multiplier
    reg [7:0] mul_a_reg;
    reg [7:0] mul_b_reg;

    // Partial products wires: 8 partial products of 16 bits each
    wire [15:0] partial_products [7:0];
    genvar i;
    generate
        for (i=0; i<8; i=i+1) begin : gen_partial_products
            assign partial_products[i] = mul_b_reg[i] ? (mul_a_reg << i) : 16'd0;
        end
    endgenerate

    // Stage 1 sums: pairs of partial products
    reg [15:0] sum0_0, sum0_1;

    // Stage 2 sums: pairs of partial products
    reg [15:0] sum1_0, sum1_1;

    // Stage 3 sums: sums of sums from previous stages
    reg [15:0] sum2_0, sum2_1;

    // Final product register
    reg [15:0] mul_out_reg;

    // 1) Shift mul_en_in to track pipeline valid data (5-stage pipeline)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mul_en_pipe <= 5'b0;
        else
            mul_en_pipe <= {mul_en_pipe[3:0], mul_en_in};
    end

    // 2) Sample inputs when mul_en_in is asserted
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_a_reg <= 8'd0;
            mul_b_reg <= 8'd0;
        end else if (mul_en_in) begin
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
        end
    end

    // 3) Pipeline Stage 1: sum pairs partial_products[0]+[1] and [2]+[3]
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum0_0 <= 16'd0;
            sum0_1 <= 16'd0;
        end else if (mul_en_pipe[0]) begin
            sum0_0 <= partial_products[0] + partial_products[1];
            sum0_1 <= partial_products[2] + partial_products[3];
        end else begin
            sum0_0 <= 16'd0;
            sum0_1 <= 16'd0;
        end
    end

    // 4) Pipeline Stage 2: sum pairs partial_products[4]+[5] and [6]+[7]
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum1_0 <= 16'd0;
            sum1_1 <= 16'd0;
        end else if (mul_en_pipe[1]) begin
            sum1_0 <= partial_products[4] + partial_products[5];
            sum1_1 <= partial_products[6] + partial_products[7];
        end else begin
            sum1_0 <= 16'd0;
            sum1_1 <= 16'd0;
        end
    end

    // 5) Pipeline Stage 3: sum sums from stage 1
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum2_0 <= 16'd0;
            sum2_1 <= 16'd0;
        end else if (mul_en_pipe[2]) begin
            sum2_0 <= sum0_0 + sum0_1;
            sum2_1 <= sum1_0 + sum1_1;
        end else begin
            sum2_0 <= 16'd0;
            sum2_1 <= 16'd0;
        end
    end

    // 6) Pipeline Stage 4: final sum of sum2_0 and sum2_1
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mul_out_reg <= 16'd0;
        else if (mul_en_pipe[3])
            mul_out_reg <= sum2_0 + sum2_1;
        else
            mul_out_reg <= 16'd0;
    end

    // 7) Output enable signal derived from MSB of enable pipeline shift register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mul_en_out <= 1'b0;
        else
            mul_en_out <= mul_en_pipe[4];
    end

    // 8) Output product: valid only when mul_en_out is asserted, else zero
    always @(*) begin
        if (mul_en_out)
            mul_out = mul_out_reg;
        else
            mul_out = 16'd0;
    end

endmodule