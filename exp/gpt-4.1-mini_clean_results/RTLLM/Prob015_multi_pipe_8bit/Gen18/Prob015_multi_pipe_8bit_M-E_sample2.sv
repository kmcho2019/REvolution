module multi_pipe_8bit (
    input           clk,
    input           rst_n,
    input           mul_en_in,
    input   [7:0]   mul_a,
    input   [7:0]   mul_b,
    output          mul_en_out,
    output  [15:0]  mul_out
);

    // Stage 1 registers: inputs and enable
    reg [7:0] mul_a_reg1;
    reg [7:0] mul_b_reg1;
    reg       mul_en_reg1;

    // Stage 2 registers: partial products and enable
    reg [15:0] pp0_reg2, pp1_reg2, pp2_reg2, pp3_reg2, pp4_reg2, pp5_reg2, pp6_reg2, pp7_reg2;
    reg        mul_en_reg2;

    // Stage 3 registers: pairwise sums of partial products and enable
    reg [15:0] sum0_reg3, sum1_reg3, sum2_reg3, sum3_reg3;
    reg        mul_en_reg3;

    // Stage 4 registers: sum of sums and enable
    reg [15:0] sum01_reg4, sum23_reg4;
    reg        mul_en_reg4;

    // Stage 5 registers: final product and enable
    reg [15:0] mul_out_reg;
    reg        mul_en_reg5;

    // Pipeline stage 1: sample inputs and enable
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_a_reg1  <= 8'd0;
            mul_b_reg1  <= 8'd0;
            mul_en_reg1 <= 1'b0;
        end else begin
            mul_en_reg1 <= mul_en_in;
            if (mul_en_in) begin
                mul_a_reg1 <= mul_a;
                mul_b_reg1 <= mul_b;
            end
        end
    end

    // Stage 2: generate partial products (registered)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            pp0_reg2 <= 16'd0; pp1_reg2 <= 16'd0; pp2_reg2 <= 16'd0; pp3_reg2 <= 16'd0;
            pp4_reg2 <= 16'd0; pp5_reg2 <= 16'd0; pp6_reg2 <= 16'd0; pp7_reg2 <= 16'd0;
            mul_en_reg2 <= 1'b0;
        end else begin
            mul_en_reg2 <= mul_en_reg1;
            if (mul_en_reg1) begin
                // Partial products: multiplicand shifted by multiplier bit if set
                pp0_reg2 <= mul_b_reg1[0] ? {8'd0, mul_a_reg1}       : 16'd0;
                pp1_reg2 <= mul_b_reg1[1] ? {7'd0, mul_a_reg1, 1'b0} : 16'd0;
                pp2_reg2 <= mul_b_reg1[2] ? {6'd0, mul_a_reg1, 2'b0} : 16'd0;
                pp3_reg2 <= mul_b_reg1[3] ? {5'd0, mul_a_reg1, 3'b0} : 16'd0;
                pp4_reg2 <= mul_b_reg1[4] ? {4'd0, mul_a_reg1, 4'b0} : 16'd0;
                pp5_reg2 <= mul_b_reg1[5] ? {3'd0, mul_a_reg1, 5'b0} : 16'd0;
                pp6_reg2 <= mul_b_reg1[6] ? {2'd0, mul_a_reg1, 6'b0} : 16'd0;
                pp7_reg2 <= mul_b_reg1[7] ? {1'd0, mul_a_reg1, 7'b0} : 16'd0;
            end else begin
                pp0_reg2 <= 16'd0; pp1_reg2 <= 16'd0; pp2_reg2 <= 16'd0; pp3_reg2 <= 16'd0;
                pp4_reg2 <= 16'd0; pp5_reg2 <= 16'd0; pp6_reg2 <= 16'd0; pp7_reg2 <= 16'd0;
            end
        end
    end

    // Stage 3: pairwise sum of partial products
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum0_reg3 <= 16'd0;
            sum1_reg3 <= 16'd0;
            sum2_reg3 <= 16'd0;
            sum3_reg3 <= 16'd0;
            mul_en_reg3 <= 1'b0;
        end else begin
            mul_en_reg3 <= mul_en_reg2;
            if (mul_en_reg2) begin
                sum0_reg3 <= pp0_reg2 + pp1_reg2;
                sum1_reg3 <= pp2_reg2 + pp3_reg2;
                sum2_reg3 <= pp4_reg2 + pp5_reg2;
                sum3_reg3 <= pp6_reg2 + pp7_reg2;
            end else begin
                sum0_reg3 <= 16'd0;
                sum1_reg3 <= 16'd0;
                sum2_reg3 <= 16'd0;
                sum3_reg3 <= 16'd0;
            end
        end
    end

    // Stage 4: sum pairs of sums
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum01_reg4 <= 16'd0;
            sum23_reg4 <= 16'd0;
            mul_en_reg4 <= 1'b0;
        end else begin
            mul_en_reg4 <= mul_en_reg3;
            if (mul_en_reg3) begin
                sum01_reg4 <= sum0_reg3 + sum1_reg3;
                sum23_reg4 <= sum2_reg3 + sum3_reg3;
            end else begin
                sum01_reg4 <= 16'd0;
                sum23_reg4 <= 16'd0;
            end
        end
    end

    // Stage 5: final product sum and enable register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out_reg <= 16'd0;
            mul_en_reg5 <= 1'b0;
        end else begin
            mul_en_reg5 <= mul_en_reg4;
            if (mul_en_reg4) begin
                mul_out_reg <= sum01_reg4 + sum23_reg4;
            end else begin
                mul_out_reg <= 16'd0;
            end
        end
    end

    // Output enable assigned from final pipeline enable register
    assign mul_en_out = mul_en_reg5;

    // Output product gated by output enable
    assign mul_out = mul_en_out ? mul_out_reg : 16'd0;

endmodule