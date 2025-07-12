module multi_pipe_8bit (
    input           clk,
    input           rst_n,
    input           mul_en_in,
    input   [7:0]   mul_a,
    input   [7:0]   mul_b,
    output          mul_en_out,
    output  [15:0]  mul_out
);

    // Pipeline enable shift register for 4 stages
    reg [3:0] mul_en_pipe;

    // Stage 1 registers: inputs
    reg [7:0] mul_a_reg;
    reg [7:0] mul_b_reg;

    // Stage 2 registers: partial products
    reg [15:0] pp0, pp1, pp2, pp3, pp4, pp5, pp6, pp7;

    // Stage 3 registers: partial sums (adder tree level 1)
    reg [15:0] sum0, sum1, sum2, sum3;

    // Stage 4 registers: partial sums (adder tree level 2)
    reg [15:0] sum01, sum23;

    // Stage 5 register: final sum (adder tree level 3)
    reg [15:0] product_reg;

    integer i;

    // Input enable and operands pipeline
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

    // Stage 2: Generate partial products based on registered inputs
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            pp0 <= 16'd0; pp1 <= 16'd0; pp2 <= 16'd0; pp3 <= 16'd0;
            pp4 <= 16'd0; pp5 <= 16'd0; pp6 <= 16'd0; pp7 <= 16'd0;
        end else if (mul_en_pipe[0]) begin
            pp0 <= mul_b_reg[0] ? {8'd0, mul_a_reg}       : 16'd0;
            pp1 <= mul_b_reg[1] ? {7'd0, mul_a_reg, 1'b0} : 16'd0;
            pp2 <= mul_b_reg[2] ? {6'd0, mul_a_reg, 2'b00}: 16'd0;
            pp3 <= mul_b_reg[3] ? {5'd0, mul_a_reg, 3'b000}:16'd0;
            pp4 <= mul_b_reg[4] ? {4'd0, mul_a_reg, 4'b0000}:16'd0;
            pp5 <= mul_b_reg[5] ? {3'd0, mul_a_reg, 5'b00000}:16'd0;
            pp6 <= mul_b_reg[6] ? {2'd0, mul_a_reg, 6'b000000}:16'd0;
            pp7 <= mul_b_reg[7] ? {1'd0, mul_a_reg, 7'b0000000}:16'd0;
        end else begin
            pp0 <= 16'd0; pp1 <= 16'd0; pp2 <= 16'd0; pp3 <= 16'd0;
            pp4 <= 16'd0; pp5 <= 16'd0; pp6 <= 16'd0; pp7 <= 16'd0;
        end
    end

    // Stage 3: Sum partial products in pairs to reduce additions
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum0 <= 16'd0; sum1 <= 16'd0; sum2 <= 16'd0; sum3 <= 16'd0;
        end else if (mul_en_pipe[1]) begin
            sum0 <= pp0 + pp1;
            sum1 <= pp2 + pp3;
            sum2 <= pp4 + pp5;
            sum3 <= pp6 + pp7;
        end else begin
            sum0 <= 16'd0; sum1 <= 16'd0; sum2 <= 16'd0; sum3 <= 16'd0;
        end
    end

    // Stage 4: Sum the previous sums in pairs
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum01 <= 16'd0; sum23 <= 16'd0;
        end else if (mul_en_pipe[2]) begin
            sum01 <= sum0 + sum1;
            sum23 <= sum2 + sum3;
        end else begin
            sum01 <= 16'd0; sum23 <= 16'd0;
        end
    end

    // Stage 5: Final sum and register output product
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            product_reg <= 16'd0;
        end else if (mul_en_pipe[3]) begin
            product_reg <= sum01 + sum23;
        end else begin
            product_reg <= 16'd0;
        end
    end

    // Output enable indicates valid product at final stage
    assign mul_en_out = mul_en_pipe[3];

    // Output mux: zero when output not valid
    assign mul_out = mul_en_out ? product_reg : 16'd0;

endmodule