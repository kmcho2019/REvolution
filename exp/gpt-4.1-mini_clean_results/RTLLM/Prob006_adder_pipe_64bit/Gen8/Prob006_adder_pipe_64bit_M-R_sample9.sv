module adder_pipe_64bit (
    input               clk,
    input               rst_n,
    input               i_en,
    input       [63:0]  adda,
    input       [63:0]  addb,
    output reg  [64:0]  result,
    output reg          o_en
);

    // Pipeline stage registers
    reg [15:0] add_a_s1, add_b_s1;
    reg        en_s1;
    reg        carry_in_s1;

    reg [15:0] add_a_s2, add_b_s2;
    reg        en_s2;
    reg        carry_in_s2;

    reg [15:0] add_a_s3, add_b_s3;
    reg        en_s3;
    reg        carry_in_s3;

    reg [15:0] add_a_s4, add_b_s4;
    reg        en_s4;
    reg        carry_in_s4;

    // Registered sums and carries per stage
    reg [15:0] sum_s1, sum_s2, sum_s3, sum_s4;
    reg        carry_out_s1, carry_out_s2, carry_out_s3, carry_out_s4;

    // Stage 1: latch inputs and calculate sum and carry
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            add_a_s1    <= 16'd0;
            add_b_s1    <= 16'd0;
            en_s1       <= 1'b0;
            carry_in_s1 <= 1'b0;
            sum_s1      <= 16'd0;
            carry_out_s1<= 1'b0;
        end else begin
            if (i_en) begin
                add_a_s1    <= adda[15:0];
                add_b_s1    <= addb[15:0];
                en_s1       <= 1'b1;
                carry_in_s1 <= 1'b0;
            end else begin
                en_s1 <= 1'b0;
            end

            // Calculate sum and carry_out for stage 1
            {carry_out_s1, sum_s1} <= add_a_s1 + add_b_s1 + carry_in_s1;
        end
    end

    // Stage 2
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            add_a_s2    <= 16'd0;
            add_b_s2    <= 16'd0;
            en_s2       <= 1'b0;
            carry_in_s2 <= 1'b0;
            sum_s2      <= 16'd0;
            carry_out_s2<= 1'b0;
        end else begin
            add_a_s2    <= adda[31:16];
            add_b_s2    <= addb[31:16];
            en_s2       <= en_s1;
            carry_in_s2 <= carry_out_s1;

            {carry_out_s2, sum_s2} <= add_a_s2 + add_b_s2 + carry_in_s2;
        end
    end

    // Stage 3
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            add_a_s3    <= 16'd0;
            add_b_s3    <= 16'd0;
            en_s3       <= 1'b0;
            carry_in_s3 <= 1'b0;
            sum_s3      <= 16'd0;
            carry_out_s3<= 1'b0;
        end else begin
            add_a_s3    <= adda[47:32];
            add_b_s3    <= addb[47:32];
            en_s3       <= en_s2;
            carry_in_s3 <= carry_out_s2;

            {carry_out_s3, sum_s3} <= add_a_s3 + add_b_s3 + carry_in_s3;
        end
    end

    // Stage 4
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            add_a_s4    <= 16'd0;
            add_b_s4    <= 16'd0;
            en_s4       <= 1'b0;
            carry_in_s4 <= 1'b0;
            sum_s4      <= 16'd0;
            carry_out_s4<= 1'b0;
        end else begin
            add_a_s4    <= adda[63:48];
            add_b_s4    <= addb[63:48];
            en_s4       <= en_s3;
            carry_in_s4 <= carry_out_s3;

            {carry_out_s4, sum_s4} <= add_a_s4 + add_b_s4 + carry_in_s4;
        end
    end

    // Output registers
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            result <= 65'd0;
            o_en   <= 1'b0;
        end else begin
            result <= {carry_out_s4, sum_s4, sum_s3, sum_s2, sum_s1};
            o_en   <= en_s4;
        end
    end

endmodule