module radix2_div(
    input clk,
    input rst,
    input sign,
    input [7:0] dividend,
    input [7:0] divisor,
    input opn_valid,
    output reg res_valid,
    output reg [15:0] result
);

parameter WIDTH = 8;

reg [WIDTH-1:0] dividend_reg;
reg [WIDTH-1:0] divisor_reg;
reg [WIDTH-1:0] neg_divisor;
reg [3:0] cnt;
reg [WIDTH+8:0] sr;  // 17-bit shift register

assign neg_divisor = ~divisor_reg + 1;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        dividend_reg <= 0;
        divisor_reg <= 0;
        sr <= 0;
        cnt <= 0;
    end else if (opn_valid) begin
        // Save inputs
        dividend_reg <= dividend;
        divisor_reg <= divisor;

        if (cnt == 0) begin
            // Initialize shift register
            if (sign) begin
                // Signed division
                sr <= {1'b0, (dividend_reg[WIDTH-1]? (~dividend_reg + 1) : dividend_reg)};  // shift left by one bit
            end else begin
                // Unsigned division
                sr <= {1'b0, dividend_reg};  // shift left by one bit
            end
            cnt <= 1;
        end else if (cnt < WIDTH) begin
            // Update shift register
            if (sr[WIDTH+8] == 0) begin
                // Subtract NEG_DIVISOR
                if (sr[WIDTH+7:WIDTH] < neg_divisor) begin
                    sr <= {1'b1, sr[WIDTH+7:WIDTH]} << 1;  // shift left and insert carry-out
                end else begin
                    sr <= {1'b0, sr[WIDTH+7:WIDTH] - neg_divisor} << 1;  // shift left and insert carry-out
                end
            end else begin
                // Subtract NEG_DIVISOR
                if ({sr[WIDTH+8], sr[WIDTH+7:WIDTH]} < {1'b0, neg_divisor}) begin
                    sr <= {1'b1, sr[WIDTH+7:WIDTH]} << 1;  // shift left and insert carry-out
                end else begin
                    sr <= {1'b0, sr[WIDTH+7:WIDTH] - neg_divisor} << 1;  // shift left and insert carry-out
                end
            end
            cnt <= cnt + 1;
        end
    end
end

always @(posedge clk or posedge rst) begin
    if (rst) begin
        res_valid <= 0;
        result <= 0;
    end else begin
        if (cnt == WIDTH) begin
            // Division complete
            result <= {sr[WIDTH+7:WIDTH], sr[WIDTH-1:0]};  // update result
            res_valid <= 1;
        end else if (!opn_valid) begin
            res_valid <= 0;
        end
    end
end

endmodule