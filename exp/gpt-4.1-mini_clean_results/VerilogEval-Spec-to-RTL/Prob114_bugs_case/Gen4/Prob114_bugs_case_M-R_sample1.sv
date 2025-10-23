module TopModule(
    input  [7:0] code,
    output [3:0] out,
    output       valid
);

// Function to map code to digit, returns 4'd0 if no match
function [3:0] code_to_digit;
    input [7:0] c;
    begin
        case (c)
            8'h45: code_to_digit = 4'd0;
            8'h16: code_to_digit = 4'd1;
            8'h1e: code_to_digit = 4'd2;
            8'h26: code_to_digit = 4'd3;
            8'h25: code_to_digit = 4'd4;
            8'h2e: code_to_digit = 4'd5;
            8'h36: code_to_digit = 4'd6;
            8'h3d: code_to_digit = 4'd7;
            8'h3e: code_to_digit = 4'd8;
            8'h46: code_to_digit = 4'd9;
            default: code_to_digit = 4'd0;
        endcase
    end
endfunction

assign out = code_to_digit(code);

assign valid = (code == 8'h45) || (code == 8'h16) || (code == 8'h1e) || (code == 8'h26) ||
               (code == 8'h25) || (code == 8'h2e) || (code == 8'h36) || (code == 8'h3d) ||
               (code == 8'h3e) || (code == 8'h46);

endmodule