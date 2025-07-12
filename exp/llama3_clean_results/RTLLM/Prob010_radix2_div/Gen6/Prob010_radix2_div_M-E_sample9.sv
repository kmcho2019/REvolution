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

reg [8:0] sr;  // shift register with 1 extra bit for carry
reg [7:0] neg_divisor;  // negated absolute value of divisor
reg [3:0] cnt;  // counter
reg start_div;  // flag to start division
reg [7:0] quotient;  // quotient
reg [7:0] remainder;  // remainder
reg [7:0] dividend_reg;  // registered dividend
reg [7:0] divisor_reg;  // registered divisor

// Input Stage
always @(posedge clk or posedge rst) begin
    if (rst) begin
        dividend_reg <= 0;
        divisor_reg <= 0;
        start_div <= 0;
    end else if (opn_valid &&!start_div) begin
        if (sign) begin
            // Signed division
            dividend_reg <= (dividend[7]? ~dividend + 1 : dividend);
            divisor_reg <= (divisor[7]? ~divisor + 1 : divisor);
        end else begin
            // Unsigned division
            dividend_reg <= dividend;
            divisor_reg <= divisor;
        end
        start_div <= 1;
    end
end

// Division Stage
always @(posedge clk or posedge rst) begin
    if (rst) begin
        sr <= 0;
        cnt <= 0;
    end else if (start_div) begin
        if (cnt == 0) begin
            sr <= {1'b0, dividend_reg};  // initialize shift register
            cnt <= 1;
        end else if (cnt < 8) begin
            if (sr[8] == 0) begin
                if (sr[7:0] >= divisor_reg) begin
                    sr <= {1'b0, sr[7:0] - divisor_reg} << 1;  // shift left and insert carry-out
                end else begin
                    sr <= {1'b1, sr[7:0]} << 1;  // shift left and insert carry-out
                end
            end else begin
                if ({sr[8], sr[7:0]} >= {1'b0, divisor_reg}) begin
                    sr <= {1'b0, sr[7:0] - divisor_reg} << 1;  // shift left and insert carry-out
                end else begin
                    sr <= {1'b1, sr[7:0]} << 1;  // shift left and insert carry-out
                end
            end
            cnt <= cnt + 1;
        end
    end
end

// Result Stage
always @(posedge clk or posedge rst) begin
    if (rst) begin
        quotient <= 0;
        remainder <= 0;
    end else if (start_div && cnt == 8) begin
        remainder <= sr[7:0];
        quotient <= sr[8];
    end
end

// Output Stage
always @(posedge clk or posedge rst) begin
    if (rst) begin
        res_valid <= 0;
        result <= 0;
    end else if (start_div && cnt == 8) begin
        res_valid <= 1;
        result <= {remainder, quotient};
    end else if (!opn_valid && res_valid) begin
        res_valid <= 0;
    end
end

endmodule