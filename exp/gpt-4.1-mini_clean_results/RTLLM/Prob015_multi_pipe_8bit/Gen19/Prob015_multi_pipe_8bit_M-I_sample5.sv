module multi_pipe_8bit (
    input               clk,
    input               rst_n,
    input               mul_en_in,
    input       [7:0]   mul_a,
    input       [7:0]   mul_b,
    output reg          mul_en_out,
    output reg  [15:0]  mul_out
);

    // Stage 1 registers: latch inputs and enable
    reg [7:0] mul_a_reg;
    reg [7:0] mul_b_reg;
    reg       mul_en_s1;

    // Stage 2 registers: partial products and enable
    reg [15:0] pp[7:0];  // partial products registered
    reg        mul_en_s2;

    // Stage 3 registers: sums of pairs of partial products
    reg [15:0] sum_level1[3:0];
    reg        mul_en_s3;

    // Stage 4 registers: sums of level 1 results
    reg [15:0] sum_level2[1:0];
    reg        mul_en_s4;

    // Stage 5 registers: final product and enable
    reg [15:0] mul_out_reg;
    reg        mul_en_s5;

    integer i;

    // Stage 1: sample inputs and enable
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_a_reg <= 8'd0;
            mul_b_reg <= 8'd0;
            mul_en_s1 <= 1'b0;
        end else begin
            mul_en_s1 <= mul_en_in;
            if (mul_en_in) begin
                mul_a_reg <= mul_a;
                mul_b_reg <= mul_b;
            end
        end
    end

    // Stage 2: generate partial products and register them
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < 8; i = i +1)
                pp[i] <= 16'd0;
            mul_en_s2 <= 1'b0;
        end else begin
            mul_en_s2 <= mul_en_s1;
            if (mul_en_s1) begin
                for (i = 0; i < 8; i = i +1)
                    pp[i] <= mul_b_reg[i] ? (mul_a_reg << i) : 16'd0;
            end
        end
    end

    // Stage 3: sum partial products pairwise and register sums
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < 4; i = i +1)
                sum_level1[i] <= 16'd0;
            mul_en_s3 <= 1'b0;
        end else begin
            mul_en_s3 <= mul_en_s2;
            if (mul_en_s2) begin
                sum_level1[0] <= pp[0] + pp[1];
                sum_level1[1] <= pp[2] + pp[3];
                sum_level1[2] <= pp[4] + pp[5];
                sum_level1[3] <= pp[6] + pp[7];
            end
        end
    end

    // Stage 4: sum pairs from previous sums and register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_level2[0] <= 16'd0;
            sum_level2[1] <= 16'd0;
            mul_en_s4 <= 1'b0;
        end else begin
            mul_en_s4 <= mul_en_s3;
            if (mul_en_s3) begin
                sum_level2[0] <= sum_level1[0] + sum_level1[1];
                sum_level2[1] <= sum_level1[2] + sum_level1[3];
            end
        end
    end

    // Stage 5: final product sum and enable register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out_reg <= 16'd0;
            mul_en_s5 <= 1'b0;
        end else begin
            mul_en_s5 <= mul_en_s4;
            if (mul_en_s4) begin
                mul_out_reg <= sum_level2[0] + sum_level2[1];
            end
        end
    end

    // Output enable register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mul_en_out <= 1'b0;
        else
            mul_en_out <= mul_en_s5;
    end

    // Output product muxed by enable
    always @(*) begin
        mul_out = mul_en_out ? mul_out_reg : 16'd0;
    end

endmodule