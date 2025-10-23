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
reg [8:0] remainder;  // remainder
reg [7:0] quotient;  // quotient
reg [3:0] cnt;  // counter

// Initialize dividend and divisor
always @(posedge clk or posedge rst) begin
    if (rst) begin
        dividend_reg <= 8'd0;
        divisor_reg <= 8'd0;
    end else if (opn_valid) begin
        dividend_reg <= (sign && dividend[7])? ~dividend + 1 : dividend;
        divisor_reg <= (sign && divisor[7])? ~divisor + 1 : divisor;
    end
end

// Perform division
always @(posedge clk or posedge rst) begin
    if (rst) begin
        remainder <= 9'd0;
        quotient <= 8'd0;
        cnt <= 4'd0;
        res_valid <= 1'b0;
    end else if (opn_valid && cnt == 4'd0) begin
        remainder <= {1'b0, dividend_reg};
        quotient <= 8'd0;
        cnt <= 4'd1;
    end else if (cnt < 4'd8) begin
        if (remainder[8]) begin
            remainder <= {remainder[7:0], 1'b0} - {1'b0, divisor_reg};
            quotient <= quotient + (1 << (cnt - 1));
        end else begin
            remainder <= {remainder[7:0], 1'b0};
        end
        cnt <= cnt + 1;
    end else begin
        result <= {remainder[7:0], quotient};
        res_valid <= 1'b1;
    end
end

endmodule