module multi_pipe_4bit #(
    parameter size = 4
)(
    input                       clk,
    input                       rst_n,
    input       [size-1:0]      mul_a,
    input       [size-1:0]      mul_b,
    output reg  [(2*size)-1:0]  mul_out
);

    // Extend multiplicand by 'size' zeros at MSB side (upper bits)
    // This is a wire input, so register it at stage 0 along with partial products
    wire [(2*size)-1:0] ext_mul_a = { {(size){1'b0}}, mul_a };

    // --- Stage 0: Register inputs and generate partial products ---
    reg [(2*size)-1:0] pp0_reg, pp1_reg, pp2_reg, pp3_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            pp0_reg <= {(2*size){1'b0}};
            pp1_reg <= {(2*size){1'b0}};
            pp2_reg <= {(2*size){1'b0}};
            pp3_reg <= {(2*size){1'b0}};
        end else begin
            // Generate partial products by wiring shifts (no shift operator for synthesis friendliness)
            // For size=4, shifts are small and can be done by wiring
            pp0_reg <= mul_b[0] ? ext_mul_a : {(2*size){1'b0}};

            // shift left by 1: insert 1 zero at LSB, drop MSB
            pp1_reg <= mul_b[1] ? {ext_mul_a[(2*size)-2:0], 1'b0} : {(2*size){1'b0}};

            // shift left by 2: insert 2 zeros at LSB, drop top 2 bits
            pp2_reg <= mul_b[2] ? {ext_mul_a[(2*size)-3:0], 2'b00} : {(2*size){1'b0}};

            // shift left by 3: insert 3 zeros at LSB, drop top 3 bits
            pp3_reg <= mul_b[3] ? {ext_mul_a[(2*size)-4:0], 3'b000} : {(2*size){1'b0}};
        end
    end

    // --- Stage 1: sum partial products pairwise ---
    reg [(2*size)-1:0] sum_stage1_reg0, sum_stage1_reg1;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_stage1_reg0 <= {(2*size){1'b0}};
            sum_stage1_reg1 <= {(2*size){1'b0}};
        end else begin
            sum_stage1_reg0 <= pp0_reg + pp1_reg;
            sum_stage1_reg1 <= pp2_reg + pp3_reg;
        end
    end

    // --- Stage 2: sum the two sums and output ---
    reg [(2*size)-1:0] sum_stage2_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_stage2_reg <= {(2*size){1'b0}};
            mul_out        <= {(2*size){1'b0}};
        end else begin
            sum_stage2_reg <= sum_stage1_reg0 + sum_stage1_reg1;
            mul_out        <= sum_stage2_reg;
        end
    end

endmodule