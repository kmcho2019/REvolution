module multi_pipe_8bit (
    input           clk,
    input           rst_n,
    input           mul_en_in,
    input   [7:0]   mul_a,
    input   [7:0]   mul_b,
    output          mul_en_out,
    output  [15:0]  mul_out
);

    // Pipeline depth: 6 stages (input, partial products, add stage1, add stage2, add stage3, output register)

    // Stage 1: Input registers
    reg mul_en_s1;
    reg [7:0] mul_a_s1;
    reg [7:0] mul_b_s1;

    // Stage 2: Partial products generation
    reg mul_en_s2;
    wire [15:0] partial_products[7:0];

    // Stage 2 registers to hold partial products
    reg [15:0] pp_s2 [7:0];

    // Stage 3: Add pairs of partial products (8->4)
    reg mul_en_s3;
    reg [15:0] sum1_s3 [3:0];

    // Stage 4: Add pairs of sums (4->2)
    reg mul_en_s4;
    reg [15:0] sum2_s4 [1:0];

    // Stage 5: Add last two sums (2->1)
    reg mul_en_s5;
    reg [15:0] sum3_s5;

    // Stage 6: Output register stage
    reg mul_en_s6;
    reg [15:0] mul_out_reg;

    integer i;

    // Stage 1: Latch inputs and input enable
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_en_s1 <= 1'b0;
            mul_a_s1 <= 8'd0;
            mul_b_s1 <= 8'd0;
        end else begin
            mul_en_s1 <= mul_en_in;
            if (mul_en_in) begin
                mul_a_s1 <= mul_a;
                mul_b_s1 <= mul_b;
            end
        end
    end

    // Stage 2: Generate partial products combinationally, then register
    // Partial products: for each bit of mul_b_s1, partial product = mul_a_s1 shifted by bit index if bit=1, else 0
    generate
        genvar idx;
        for (idx = 0; idx < 8; idx = idx + 1) begin : gen_partial_products
            assign partial_products[idx] = mul_b_s1[idx] ? (mul_a_s1 << idx) : 16'd0;
        end
    endgenerate

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_en_s2 <= 1'b0;
            for (i = 0; i < 8; i = i + 1) begin
                pp_s2[i] <= 16'd0;
            end
        end else begin
            mul_en_s2 <= mul_en_s1;
            if (mul_en_s1) begin
                for (i = 0; i < 8; i = i + 1) begin
                    pp_s2[i] <= partial_products[i];
                end
            end else begin
                for (i = 0; i < 8; i = i + 1) begin
                    pp_s2[i] <= 16'd0;
                end
            end
        end
    end

    // Stage 3: Add pairs of partial products (8->4)
    // sum1_s3[0] = pp_s2[0] + pp_s2[1]
    // sum1_s3[1] = pp_s2[2] + pp_s2[3]
    // sum1_s3[2] = pp_s2[4] + pp_s2[5]
    // sum1_s3[3] = pp_s2[6] + pp_s2[7]
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_en_s3 <= 1'b0;
            for (i = 0; i < 4; i = i + 1) begin
                sum1_s3[i] <= 16'd0;
            end
        end else begin
            mul_en_s3 <= mul_en_s2;
            if (mul_en_s2) begin
                sum1_s3[0] <= pp_s2[0] + pp_s2[1];
                sum1_s3[1] <= pp_s2[2] + pp_s2[3];
                sum1_s3[2] <= pp_s2[4] + pp_s2[5];
                sum1_s3[3] <= pp_s2[6] + pp_s2[7];
            end else begin
                for (i = 0; i < 4; i = i + 1) begin
                    sum1_s3[i] <= 16'd0;
                end
            end
        end
    end

    // Stage 4: Add pairs of sums (4->2)
    // sum2_s4[0] = sum1_s3[0] + sum1_s3[1]
    // sum2_s4[1] = sum1_s3[2] + sum1_s3[3]
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_en_s4 <= 1'b0;
            sum2_s4[0] <= 16'd0;
            sum2_s4[1] <= 16'd0;
        end else begin
            mul_en_s4 <= mul_en_s3;
            if (mul_en_s3) begin
                sum2_s4[0] <= sum1_s3[0] + sum1_s3[1];
                sum2_s4[1] <= sum1_s3[2] + sum1_s3[3];
            end else begin
                sum2_s4[0] <= 16'd0;
                sum2_s4[1] <= 16'd0;
            end
        end
    end

    // Stage 5: Add last two sums (2->1)
    // sum3_s5 = sum2_s4[0] + sum2_s4[1]
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_en_s5 <= 1'b0;
            sum3_s5 <= 16'd0;
        end else begin
            mul_en_s5 <= mul_en_s4;
            if (mul_en_s4) begin
                sum3_s5 <= sum2_s4[0] + sum2_s4[1];
            end else begin
                sum3_s5 <= 16'd0;
            end
        end
    end

    // Stage 6: Register the final product and output enable
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_en_s6 <= 1'b0;
            mul_out_reg <= 16'd0;
        end else begin
            mul_en_s6 <= mul_en_s5;
            if (mul_en_s5) begin
                mul_out_reg <= sum3_s5;
            end else begin
                mul_out_reg <= 16'd0;
            end
        end
    end

    // Output enable is mul_en_s6
    assign mul_en_out = mul_en_s6;

    // Output product: valid when output enable is high, else 0
    assign mul_out = mul_en_out ? mul_out_reg : 16'd0;

endmodule