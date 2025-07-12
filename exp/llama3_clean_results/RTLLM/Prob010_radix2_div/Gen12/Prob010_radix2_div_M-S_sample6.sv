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

reg [7:0] dividend_reg;
reg [7:0] divisor_reg;
reg [7:0] quotient;
reg [7:0] remainder;
reg [3:0] counter;
reg start;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        dividend_reg <= 0;
        divisor_reg <= 0;
        quotient <= 0;
        remainder <= 0;
        counter <= 0;
        start <= 0;
        res_valid <= 0;
    end else begin
        if (opn_valid &&!res_valid) begin
            if (sign) begin
                dividend_reg <= (dividend[7]? ~dividend + 1 : dividend);
                divisor_reg <= (divisor[7]? ~divisor + 1 : divisor);
            end else begin
                dividend_reg <= dividend;
                divisor_reg <= divisor;
            end
            remainder <= {1'b0, dividend_reg};
            quotient <= 0;
            counter <= 1;
            start <= 1;
            res_valid <= 0;
        end

        if (start) begin
            if (counter < 9) begin
                reg [8:0] temp;
                temp <= {1'b0, remainder} - divisor_reg;
                if (temp[8]) begin
                    remainder <= {1'b0, remainder};
                    quotient <= quotient << 1;
                end else begin
                    remainder <= temp[7:0];
                    quotient <= (quotient << 1) | 1'b1;
                end
                counter <= counter + 1;
            end else begin
                if (sign) begin
                    if (dividend[7]!= divisor[7]) begin
                        result <= {~remainder + 1, ~quotient + 1};
                    end else begin
                        result <= {remainder, quotient};
                    end
                end else begin
                    result <= {remainder, quotient};
                end
                res_valid <= 1;
                start <= 0;
            end
        end
    end
end

endmodule