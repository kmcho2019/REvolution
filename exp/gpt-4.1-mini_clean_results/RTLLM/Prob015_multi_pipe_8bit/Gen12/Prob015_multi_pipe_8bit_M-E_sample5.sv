module multi_pipe_8bit (
    input              clk,
    input              rst_n,
    input              mul_en_in,
    input      [7:0]   mul_a,
    input      [7:0]   mul_b,
    output reg         mul_en_out,
    output reg [15:0]  mul_out
);

// Pipeline stage registers

// Stage 1 registers: capture inputs and enable
reg        mul_en_s1;
reg [7:0]  mul_a_s1;
reg [7:0]  mul_b_s1;

// Stage 2 registers: partial products and intermediate sums
reg        mul_en_s2;
reg [15:0] pp0_s2; // partial product 0 (bit 0)
reg [15:0] pp1_s2; // partial product 1 (bit 1)
reg [15:0] pp2_s2; // partial product 2 (bit 2)
reg [15:0] pp3_s2; // partial product 3 (bit 3)
reg [15:0] pp4_s2; // partial product 4 (bit 4)
reg [15:0] pp5_s2; // partial product 5 (bit 5)
reg [15:0] pp6_s2; // partial product 6 (bit 6)
reg [15:0] pp7_s2; // partial product 7 (bit 7)

reg [15:0] sum_01_s2; // pp0 + pp1
reg [15:0] sum_23_s2; // pp2 + pp3
reg [15:0] sum_45_s2; // pp4 + pp5
reg [15:0] sum_67_s2; // pp6 + pp7

// Stage 3 registers: final sum and enable
reg        mul_en_s3;
reg [15:0] sum_0123_s3; // sum_01 + sum_23
reg [15:0] sum_4567_s3; // sum_45 + sum_67
reg [15:0] mul_out_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset Stage 1
        mul_en_s1 <= 1'b0;
        mul_a_s1  <= 8'd0;
        mul_b_s1  <= 8'd0;

        // Reset Stage 2
        mul_en_s2  <= 1'b0;
        pp0_s2     <= 16'd0;
        pp1_s2     <= 16'd0;
        pp2_s2     <= 16'd0;
        pp3_s2     <= 16'd0;
        pp4_s2     <= 16'd0;
        pp5_s2     <= 16'd0;
        pp6_s2     <= 16'd0;
        pp7_s2     <= 16'd0;
        sum_01_s2  <= 16'd0;
        sum_23_s2  <= 16'd0;
        sum_45_s2  <= 16'd0;
        sum_67_s2  <= 16'd0;

        // Reset Stage 3
        mul_en_s3     <= 1'b0;
        sum_0123_s3   <= 16'd0;
        sum_4567_s3   <= 16'd0;
        mul_out_reg   <= 16'd0;

        // Outputs
        mul_en_out <= 1'b0;
        mul_out    <= 16'd0;
    end else begin
        // Stage 1: Capture inputs and enable
        mul_en_s1 <= mul_en_in;
        if (mul_en_in) begin
            mul_a_s1 <= mul_a;
            mul_b_s1 <= mul_b;
        end else begin
            mul_a_s1 <= 8'd0;
            mul_b_s1 <= 8'd0;
        end

        // Stage 2: Generate partial products and partial sums
        mul_en_s2 <= mul_en_s1;

        // Partial products: multiplicand shifted by bit index and masked by multiplier bit
        pp0_s2 <= mul_en_s1 && mul_b_s1[0] ? ({8'd0, mul_a_s1} << 0) : 16'd0;
        pp1_s2 <= mul_en_s1 && mul_b_s1[1] ? ({8'd0, mul_a_s1} << 1) : 16'd0;
        pp2_s2 <= mul_en_s1 && mul_b_s1[2] ? ({8'd0, mul_a_s1} << 2) : 16'd0;
        pp3_s2 <= mul_en_s1 && mul_b_s1[3] ? ({8'd0, mul_a_s1} << 3) : 16'd0;
        pp4_s2 <= mul_en_s1 && mul_b_s1[4] ? ({8'd0, mul_a_s1} << 4) : 16'd0;
        pp5_s2 <= mul_en_s1 && mul_b_s1[5] ? ({8'd0, mul_a_s1} << 5) : 16'd0;
        pp6_s2 <= mul_en_s1 && mul_b_s1[6] ? ({8'd0, mul_a_s1} << 6) : 16'd0;
        pp7_s2 <= mul_en_s1 && mul_b_s1[7] ? ({8'd0, mul_a_s1} << 7) : 16'd0;

        // Partial sums to reduce adder tree depth
        sum_01_s2 <= pp0_s2 + pp1_s2;
        sum_23_s2 <= pp2_s2 + pp3_s2;
        sum_45_s2 <= pp4_s2 + pp5_s2;
        sum_67_s2 <= pp6_s2 + pp7_s2;

        // Stage 3: Final sums and register output
        mul_en_s3 <= mul_en_s2;

        sum_0123_s3 <= sum_01_s2 + sum_23_s2;
        sum_4567_s3 <= sum_45_s2 + sum_67_s2;

        mul_out_reg <= sum_0123_s3 + sum_4567_s3;

        // Output assignment
        mul_en_out <= mul_en_s3;
        mul_out    <= mul_en_s3 ? mul_out_reg : 16'd0;
    end
end

endmodule