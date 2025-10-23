module multi_pipe_8bit (
    input               clk,
    input               rst_n,
    input               mul_en_in,
    input       [7:0]   mul_a,
    input       [7:0]   mul_b,
    output reg          mul_en_out,
    output reg  [15:0]  mul_out
);

    // Stage 1 registers: capture inputs and enable
    reg         mul_en_s1;
    reg [7:0]   mul_a_s1;
    reg [7:0]   mul_b_s1;

    // Stage 2 registers: partial products and enable
    reg         mul_en_s2;
    reg [15:0]  pp0_s2, pp1_s2, pp2_s2, pp3_s2,
                pp4_s2, pp5_s2, pp6_s2, pp7_s2;

    // Stage 3 registers: partial sums and enable
    reg         mul_en_s3;
    reg [15:0]  sum_01_s3, sum_23_s3, sum_45_s3, sum_67_s3;

    // Stage 4 registers: final product and enable
    reg         mul_en_s4;
    reg [15:0]  mul_out_reg;

    // Stage 1: Input capture
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_en_s1 <= 1'b0;
            mul_a_s1  <= 8'd0;
            mul_b_s1  <= 8'd0;
        end else begin
            mul_en_s1 <= mul_en_in;
            if (mul_en_in) begin
                mul_a_s1 <= mul_a;
                mul_b_s1 <= mul_b;
            end
        end
    end

    // Stage 2: Generate and register partial products
    wire [15:0] pp_w [7:0];
    genvar i;
    generate
        for (i=0; i<8; i=i+1) begin : gen_partial_products
            assign pp_w[i] = mul_b_s1[i] ? (mul_a_s1 << i) : 16'd0;
        end
    endgenerate

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_en_s2 <= 1'b0;
            pp0_s2 <= 16'd0; pp1_s2 <= 16'd0; pp2_s2 <= 16'd0; pp3_s2 <= 16'd0;
            pp4_s2 <= 16'd0; pp5_s2 <= 16'd0; pp6_s2 <= 16'd0; pp7_s2 <= 16'd0;
        end else begin
            mul_en_s2 <= mul_en_s1;
            if (mul_en_s1) begin
                pp0_s2 <= pp_w[0];
                pp1_s2 <= pp_w[1];
                pp2_s2 <= pp_w[2];
                pp3_s2 <= pp_w[3];
                pp4_s2 <= pp_w[4];
                pp5_s2 <= pp_w[5];
                pp6_s2 <= pp_w[6];
                pp7_s2 <= pp_w[7];
            end else begin
                pp0_s2 <= 16'd0;
                pp1_s2 <= 16'd0;
                pp2_s2 <= 16'd0;
                pp3_s2 <= 16'd0;
                pp4_s2 <= 16'd0;
                pp5_s2 <= 16'd0;
                pp6_s2 <= 16'd0;
                pp7_s2 <= 16'd0;
            end
        end
    end

    // Stage 3: Sum partial products in pairs
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_en_s3  <= 1'b0;
            sum_01_s3 <= 16'd0;
            sum_23_s3 <= 16'd0;
            sum_45_s3 <= 16'd0;
            sum_67_s3 <= 16'd0;
        end else begin
            mul_en_s3 <= mul_en_s2;
            if (mul_en_s2) begin
                sum_01_s3 <= pp0_s2 + pp1_s2;
                sum_23_s3 <= pp2_s2 + pp3_s2;
                sum_45_s3 <= pp4_s2 + pp5_s2;
                sum_67_s3 <= pp6_s2 + pp7_s2;
            end else begin
                sum_01_s3 <= 16'd0;
                sum_23_s3 <= 16'd0;
                sum_45_s3 <= 16'd0;
                sum_67_s3 <= 16'd0;
            end
        end
    end

    // Stage 4: Sum partial sums to final product
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_en_s4   <= 1'b0;
            mul_out_reg <= 16'd0;
        end else begin
            mul_en_s4 <= mul_en_s3;
            if (mul_en_s3) begin
                mul_out_reg <= (sum_01_s3 + sum_23_s3) + (sum_45_s3 + sum_67_s3);
            end else begin
                mul_out_reg <= 16'd0;
            end
        end
    end

    // Output assignment
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_en_out <= 1'b0;
            mul_out    <= 16'd0;
        end else begin
            mul_en_out <= mul_en_s4;
            mul_out    <= mul_en_s4 ? mul_out_reg : 16'd0;
        end
    end

endmodule