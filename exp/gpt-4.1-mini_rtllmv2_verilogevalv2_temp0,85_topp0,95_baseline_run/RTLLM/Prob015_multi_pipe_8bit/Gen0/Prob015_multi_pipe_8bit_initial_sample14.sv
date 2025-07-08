module multi_pipe_8bit (
    input            clk,
    input            rst_n,
    input            mul_en_in,
    input      [7:0] mul_a,
    input      [7:0] mul_b,
    output           mul_en_out,
    output reg [15:0] mul_out
);

    // Stage 1 registers: input enable and inputs
    reg mul_en_st1;
    reg [7:0] mul_a_reg_st1;
    reg [7:0] mul_b_reg_st1;

    // Stage 2: partial products - each partial product is mul_a AND a single bit of mul_b, shifted accordingly
    reg mul_en_st2;
    reg [15:0] pp [7:0]; // partial products stored in registers stage 2

    // Stage 3: sums of partial products (reduce 8 partial products into 4 sums)
    reg mul_en_st3;
    reg [15:0] sum_stage3_0, sum_stage3_1, sum_stage3_2, sum_stage3_3;

    // Stage 4: sums of sums (reduce 4 sums into 2 sums)
    reg mul_en_st4;
    reg [15:0] sum_stage4_0, sum_stage4_1;

    // Stage 5: final sum of last two sums
    reg mul_en_st5;
    reg [15:0] mul_out_reg;

    // Stage 1: Register inputs and input enable
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_en_st1    <= 1'b0;
            mul_a_reg_st1 <= 8'd0;
            mul_b_reg_st1 <= 8'd0;
        end else begin
            mul_en_st1    <= mul_en_in;
            if (mul_en_in) begin
                mul_a_reg_st1 <= mul_a;
                mul_b_reg_st1 <= mul_b;
            end
        end
    end

    // Stage 2: Generate partial products and register them along with enable
    integer i;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_en_st2 <= 1'b0;
            for (i=0; i<8; i=i+1) begin
                pp[i] <= 16'd0;
            end
        end else begin
            mul_en_st2 <= mul_en_st1;
            if (mul_en_st1) begin
                for (i=0; i<8; i=i+1) begin
                    // partial product = (bit i of mul_b) ? mul_a << i : 0
                    pp[i] <= mul_b_reg_st1[i] ? ( {8'd0, mul_a_reg_st1} << i ) : 16'd0;
                end
            end else begin
                for (i=0; i<8; i=i+1) begin
                    pp[i] <= 16'd0;
                end
            end
        end
    end

    // Stage 3: Add partial products pairwise: (pp0+pp1), (pp2+pp3), (pp4+pp5), (pp6+pp7)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_en_st3   <= 1'b0;
            sum_stage3_0 <= 16'd0;
            sum_stage3_1 <= 16'd0;
            sum_stage3_2 <= 16'd0;
            sum_stage3_3 <= 16'd0;
        end else begin
            mul_en_st3 <= mul_en_st2;
            if (mul_en_st2) begin
                sum_stage3_0 <= pp[0] + pp[1];
                sum_stage3_1 <= pp[2] + pp[3];
                sum_stage3_2 <= pp[4] + pp[5];
                sum_stage3_3 <= pp[6] + pp[7];
            end else begin
                sum_stage3_0 <= 16'd0;
                sum_stage3_1 <= 16'd0;
                sum_stage3_2 <= 16'd0;
                sum_stage3_3 <= 16'd0;
            end
        end
    end

    // Stage 4: Add sums from stage 3 pairwise: (sum_stage3_0 + sum_stage3_1), (sum_stage3_2 + sum_stage3_3)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_en_st4   <= 1'b0;
            sum_stage4_0 <= 16'd0;
            sum_stage4_1 <= 16'd0;
        end else begin
            mul_en_st4 <= mul_en_st3;
            if (mul_en_st3) begin
                sum_stage4_0 <= sum_stage3_0 + sum_stage3_1;
                sum_stage4_1 <= sum_stage3_2 + sum_stage3_3;
            end else begin
                sum_stage4_0 <= 16'd0;
                sum_stage4_1 <= 16'd0;
            end
        end
    end

    // Stage 5: Final addition to produce product
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_en_st5   <= 1'b0;
            mul_out_reg  <= 16'd0;
        end else begin
            mul_en_st5 <= mul_en_st4;
            if (mul_en_st4) begin
                mul_out_reg <= sum_stage4_0 + sum_stage4_1;
            end else begin
                mul_out_reg <= 16'd0;
            end
        end
    end

    // Output enable from the last pipeline stage
    assign mul_en_out = mul_en_st5;

    // Output product register with enable control
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out <= 16'd0;
        end else begin
            if (mul_en_st5)
                mul_out <= mul_out_reg;
            else
                mul_out <= 16'd0;
        end
    end

endmodule