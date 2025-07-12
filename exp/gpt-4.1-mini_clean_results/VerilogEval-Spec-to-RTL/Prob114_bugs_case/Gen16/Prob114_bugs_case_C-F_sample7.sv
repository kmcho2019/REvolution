module TopModule (
    input  [7:0] code,
    output [3:0] out,
    output valid
);

function [4:0] decode_scancode;
    input [7:0] scode;
    begin
        case (scode)
            8'h45: decode_scancode = 5'b0_0000; // digit 0, valid=1
            8'h16: decode_scancode = 5'b1_0001; // digit 1, valid=1
            8'h1E: decode_scancode = 5'b1_0010; // digit 2, valid=1
            8'h26: decode_scancode = 5'b1_0011; // digit 3, valid=1
            8'h25: decode_scancode = 5'b1_0100; // digit 4, valid=1
            8'h2E: decode_scancode = 5'b1_0101; // digit 5, valid=1
            8'h36: decode_scancode = 5'b1_0110; // digit 6, valid=1
            8'h3D: decode_scancode = 5'b1_0111; // digit 7, valid=1
            8'h3E: decode_scancode = 5'b1_1000; // digit 8, valid=1
            8'h46: decode_scancode = 5'b1_1001; // digit 9, valid=1
            default: decode_scancode = 5'b0_0000; // invalid, digit=0, valid=0
        endcase
    end
endfunction

wire [4:0] decoded = decode_scancode(code);

assign valid = decoded[4];
assign out = decoded[3:0];

endmodule