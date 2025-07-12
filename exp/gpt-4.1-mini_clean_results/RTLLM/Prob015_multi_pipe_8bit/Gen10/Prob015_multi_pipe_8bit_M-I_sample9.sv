module multi_pipe_8bit (
    input           clk,
    input           rst_n,
    input           mul_en_in,
    input   [7:0]   mul_a,
    input   [7:0]   mul_b,
    output reg      mul_en_out,
    output reg [15:0] mul_out
);

    // Pipeline register for mul_en_in signal propagation (6 stages)
    reg [5:0] mul_en_pipe;

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

    // Stage 1 partial sums: split sum0 and sum1 additions into two 2-input adds each
    // sum0 partial sums
    reg [15:0] sum0_0; // partial_products[0] + partial_products[1]
    reg [15:0] sum0_1; // partial_products[2] held for next stage

    // sum1 partial sums
    reg [15:0] sum1_0; // partial_products[3] + partial_products[4]
    reg [15:0] sum1_1; // partial_products[5] held for next stage

    // sum2 partial sum: partial_products[6] + partial_products[7]
    reg [15:0] sum2;

    // Stage 2 partial sums: sum0_0 + sum0_1, sum1_0 + sum1_1
    reg [15:0] sum0;
    reg [15:0] sum1;

    // Stage 3: sum of sum0 + sum1
    reg [15:0] sum01;

    // Stage 4 (final): sum of sum01 + sum2
    reg [15:0] mul_out_reg;

    // 1) Shift mul_en_in to track pipeline valid data (6 stages)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mul_en_pipe <= 6'b0;
        else
            mul_en_pipe <= {mul_en_pipe[4:0], mul_en_in};
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

    // 3) Stage 1: sum pairs of partial products (two 2-input adds per group), hold one for next stage
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum0_0 <= 16'd0;
            sum0_1 <= 16'd0;
            sum1_0 <= 16'd0;
            sum1_1 <= 16'd0;
            sum2   <= 16'd0;
        end else begin
            // sum0_0: partial_products[0] + partial_products[1]
            if (mul_en_pipe[0])
                sum0_0 <= partial_products[0] + partial_products[1];
            else
                sum0_0 <= 16'd0;
            // sum0_1: partial_products[2]
            if (mul_en_pipe[0])
                sum0_1 <= partial_products[2];
            else
                sum0_1 <= 16'd0;

            // sum1_0: partial_products[3] + partial_products[4]
            if (mul_en_pipe[0])
                sum1_0 <= partial_products[3] + partial_products[4];
            else
                sum1_0 <= 16'd0;
            // sum1_1: partial_products[5]
            if (mul_en_pipe[0])
                sum1_1 <= partial_products[5];
            else
                sum1_1 <= 16'd0;

            // sum2: partial_products[6] + partial_products[7]
            if (mul_en_pipe[0])
                sum2 <= partial_products[6] + partial_products[7];
            else
                sum2 <= 16'd0;
        end
    end

    // 4) Stage 2: add sum0_0 + sum0_1 and sum1_0 + sum1_1
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum0 <= 16'd0;
            sum1 <= 16'd0;
        end else begin
            if (mul_en_pipe[1]) begin
                sum0 <= sum0_0 + sum0_1;
                sum1 <= sum1_0 + sum1_1;
            end else begin
                sum0 <= 16'd0;
                sum1 <= 16'd0;
            end
        end
    end

    // 5) Stage 3: sum of sum0 + sum1
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            sum01 <= 16'd0;
        else if (mul_en_pipe[2])
            sum01 <= sum0 + sum1;
        else
            sum01 <= 16'd0;
    end

    // 6) Stage 4 (final): sum of sum01 + sum2
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mul_out_reg <= 16'd0;
        else if (mul_en_pipe[3])
            mul_out_reg <= sum01 + sum2;
        else
            mul_out_reg <= 16'd0;
    end

    // Output enable is mul_en_pipe stage 4
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mul_en_out <= 1'b0;
        else
            mul_en_out <= mul_en_pipe[3];
    end

    // Output product: valid only when mul_en_out is asserted, else zero
    always @(*) begin
        if (mul_en_out)
            mul_out = mul_out_reg;
        else
            mul_out = 16'd0;
    end

endmodule