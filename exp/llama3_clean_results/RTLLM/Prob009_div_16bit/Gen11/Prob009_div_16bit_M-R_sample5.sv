module div_16bit(
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
);

assign result = (B == 0)? 16'hFFFF : get_quotient(A, B);
assign odd = (B == 0)? 16'hFFFF : get_remainder(A, B);

function [15:0] get_quotient;
    input [15:0] dividend;
    input [7:0] divisor;
    reg [15:0] quotient;
    reg [15:0] temp_dividend;
    begin
        temp_dividend = dividend;
        quotient = 0;
        for (int i = 15; i >= 7; i--) begin
            if (temp_dividend[15:8] >= divisor) begin
                quotient[15 - i] = 1'b1;
                temp_dividend[15:8] = temp_dividend[15:8] - divisor;
            end else begin
                quotient[15 - i] = 1'b0;
            end
            
            if (i > 7) begin
                temp_dividend[15:8] = {temp_dividend[7], temp_dividend[7:1]};
                temp_dividend[7:0] = {8'd0, temp_dividend[0]};
            end
        end
        get_quotient = quotient;
    end
endfunction

function [15:0] get_remainder;
    input [15:0] dividend;
    input [7:0] divisor;
    reg [15:0] remainder;
    reg [15:0] temp_dividend;
    begin
        temp_dividend = dividend;
        remainder = 0;
        for (int i = 15; i >= 7; i--) begin
            if (temp_dividend[15:8] >= divisor) begin
                temp_dividend[15:8] = temp_dividend[15:8] - divisor;
            end
            
            if (i > 7) begin
                temp_dividend[15:8] = {temp_dividend[7], temp_dividend[7:1]};
                temp_dividend[7:0] = {8'd0, temp_dividend[0]};
            end
        end
        remainder = {8'd0, temp_dividend[7:0]};
        get_remainder = remainder;
    end
endfunction

endmodule