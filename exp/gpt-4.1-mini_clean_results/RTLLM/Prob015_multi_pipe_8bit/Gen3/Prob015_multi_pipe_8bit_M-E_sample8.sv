module multi_pipe_8bit (
    input               clk,
    input               rst_n,
    input               mul_en_in,
    input       [7:0]   mul_a,
    input       [7:0]   mul_b,
    output reg          mul_en_out,
    output reg  [15:0]  mul_out
);

    // Stage 1 registers
    reg mul_en_1;
    reg [7:0] mul_a_reg, mul_b_reg;
    reg [15:0] pp0, pp1, pp2, pp3, pp4, pp5, pp6, pp7;

    // Stage 2 registers
    reg mul_en_2;
    reg [15:0] sum_01, sum_23, sum_45, sum_67;

    // Stage 3 registers and output
    reg mul_en_3;
    reg [15:0] sum_0123, sum_4567;
    reg [15:0] final_sum;

    // Stage 1: Input registration and partial product generation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_en_1 <= 1'b0;
            mul_a_reg <= 8'd0;
            mul_b_reg <= 8'd0;
            pp0 <= 16'd0; pp1 <= 16'd0; pp2 <= 16'd0; pp3 <= 16'd0;
            pp4 <= 16'd0; pp5 <= 16'd0; pp6 <= 16'd0; pp7 <= 16'd0;
        end else begin
            mul_en_1 <= mul_en_in;
            if (mul_en_in) begin
                mul_a_reg <= mul_a;
                mul_b_reg <= mul_b;
                // Generate partial products: (mul_b_reg bit) ? mul_a_reg shifted by bit index : 0
                pp0 <= mul_b[0] ? {8'd0, mul_a} << 0 : 16'd0;
                pp1 <= mul_b[1] ? {8'd0, mul_a} << 1 : 16'd0;
                pp2 <= mul_b[2] ? {8'd0, mul_a} << 2 : 16'd0;
                pp3 <= mul_b[3] ? {8'd0, mul_a} << 3 : 16'd0;
                pp4 <= mul_b[4] ? {8'd0, mul_a} << 4 : 16'd0;
                pp5 <= mul_b[5] ? {8'd0, mul_a} << 5 : 16'd0;
                pp6 <= mul_b[6] ? {8'd0, mul_a} << 6 : 16'd0;
                pp7 <= mul_b[7] ? {8'd0, mul_a} << 7 : 16'd0;
            end else begin
                mul_a_reg <= mul_a_reg;
                mul_b_reg <= mul_b_reg;
                pp0 <= 16'd0; pp1 <= 16'd0; pp2 <= 16'd0; pp3 <= 16'd0;
                pp4 <= 16'd0; pp5 <= 16'd0; pp6 <= 16'd0; pp7 <= 16'd0;
            end
        end
    end

    // Stage 2: Sum partial products pairwise and register enable
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_en_2 <= 1'b0;
            sum_01 <= 16'd0; sum_23 <= 16'd0; sum_45 <= 16'd0; sum_67 <= 16'd0;
        end else begin
            mul_en_2 <= mul_en_1;
            if (mul_en_1) begin
                sum_01 <= pp0 + pp1;
                sum_23 <= pp2 + pp3;
                sum_45 <= pp4 + pp5;
                sum_67 <= pp6 + pp7;
            end else begin
                sum_01 <= 16'd0; sum_23 <= 16'd0; sum_45 <= 16'd0; sum_67 <= 16'd0;
            end
        end
    end

    // Stage 3: Sum the results of stage 2 and output register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_en_3 <= 1'b0;
            sum_0123 <= 16'd0;
            sum_4567 <= 16'd0;
            final_sum <= 16'd0;
            mul_out <= 16'd0;
            mul_en_out <= 1'b0;
        end else begin
            mul_en_3 <= mul_en_2;
            if (mul_en_2) begin
                sum_0123 <= sum_01 + sum_23;
                sum_4567 <= sum_45 + sum_67;
            end else begin
                sum_0123 <= 16'd0;
                sum_4567 <= 16'd0;
            end

            if (mul_en_3) begin
                final_sum <= sum_0123 + sum_4567;
                mul_out <= final_sum;
                mul_en_out <= 1'b1;
            end else begin
                final_sum <= 16'd0;
                mul_out <= 16'd0;
                mul_en_out <= 1'b0;
            end
        end
    end

endmodule