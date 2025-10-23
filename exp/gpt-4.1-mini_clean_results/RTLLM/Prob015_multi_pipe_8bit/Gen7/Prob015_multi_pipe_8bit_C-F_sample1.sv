module multi_pipe_8bit (
    input           clk,
    input           rst_n,
    input           mul_en_in,
    input   [7:0]   mul_a,
    input   [7:0]   mul_b,
    output reg      mul_en_out,
    output reg [15:0] mul_out
);

    // Pipeline register for mul_en_in signal propagation (4 stages)
    reg [3:0] mul_en_pipe;

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

    // Pipeline sum registers for partial sums:
    // Stage 1: sum of partial_products[0..2]
    reg [15:0] sum0;
    // Stage 2: sum of partial_products[3..5]
    reg [15:0] sum1;
    // Stage 3: sum of partial_products[6..7]
    reg [15:0] sum2;
    // Final stage: sum of sums from stages 1-3
    reg [15:0] mul_out_reg;

    // 1) Shift mul_en_in to track pipeline valid data
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mul_en_pipe <= 4'b0;
        else
            mul_en_pipe <= {mul_en_pipe[2:0], mul_en_in};
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

    // 3) Pipeline Stage 1: sum partial_products[0..2] and register if valid
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            sum0 <= 16'd0;
        else if (mul_en_pipe[0])
            sum0 <= partial_products[0] + partial_products[1] + partial_products[2];
        else
            sum0 <= 16'd0;
    end

    // 4) Pipeline Stage 2: sum partial_products[3..5] and register if valid
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            sum1 <= 16'd0;
        else if (mul_en_pipe[1])
            sum1 <= partial_products[3] + partial_products[4] + partial_products[5];
        else
            sum1 <= 16'd0;
    end

    // 5) Pipeline Stage 3: sum partial_products[6..7] and register if valid
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            sum2 <= 16'd0;
        else if (mul_en_pipe[2])
            sum2 <= partial_products[6] + partial_products[7];
        else
            sum2 <= 16'd0;
    end

    // 6) Final pipeline stage: sum the three partial sums and register if valid
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mul_out_reg <= 16'd0;
        else if (mul_en_pipe[3])
            mul_out_reg <= sum0 + sum1 + sum2;
        else
            mul_out_reg <= 16'd0;
    end

    // 7) Output enable signal derived from MSB of enable pipeline shift register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mul_en_out <= 1'b0;
        else
            mul_en_out <= mul_en_pipe[3];
    end

    // 8) Output product: valid only when mul_en_out is asserted, else zero
    always @(*) begin
        if (mul_en_out)
            mul_out = mul_out_reg;
        else
            mul_out = 16'd0;
    end

endmodule