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

reg [7:0] dividend_reg;  // registered dividend
reg [7:0] divisor_reg;  // registered divisor
reg [15:0] sr;  // shift register with 8 extra bits for remainder and quotient
reg [3:0] cnt;  // counter
reg [7:0] quotient;  // quotient
reg [7:0] remainder;  // remainder
reg start_cnt;  // start counter signal
reg neg_divisor;  // negated absolute value of divisor

// Initialize the registers
always @(posedge clk or posedge rst) begin
    if (rst) begin
        dividend_reg <= 0;
        divisor_reg <= 0;
        sr <= 0;
        cnt <= 0;
        quotient <= 0;
        remainder <= 0;
        start_cnt <= 0;
        neg_divisor <= 0;
        res_valid <= 0;
    end else begin
        if (opn_valid &&!res_valid) begin
            // Save inputs
            dividend_reg <= sign? (dividend[7]? ~dividend + 1 : dividend) : dividend;
            divisor_reg <= sign? (divisor[7]? ~divisor + 1 : divisor) : divisor;
            // Initialize shift register and counter
            sr <= {8'd0, dividend_reg};
            cnt <= 1;
            start_cnt <= 1;
        end

        if (start_cnt) begin
            if (cnt < 8) begin
                // Perform division
                if (sr[15:8] >= divisor_reg) begin
                    sr <= {sr[15:8] - divisor_reg, sr[7:0], 1'b1};
                end else begin
                    sr <= {sr[15:8], sr[7:0], 1'b0};
                end
                cnt <= cnt + 1;
            end else begin
                // Update remainder and quotient
                remainder <= sr[15:8];
                quotient <= sr[7:0];
                start_cnt <= 0;
                res_valid <= 1;
            end
        end
    end
end

// Update the output result
always @(posedge clk) begin
    result <= {remainder, quotient};
end

endmodule