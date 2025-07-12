module TopModule(
    input  [7:0] code,
    output [3:0] out,
    output valid
);

function [4:0] decode_code;
    input [7:0] code_in;
    begin
        case (code_in)
            8'h45: decode_code = 5'b1_0000; // valid=1, out=0
            8'h16: decode_code = 5'b1_0001; // valid=1, out=1
            8'h1e: decode_code = 5'b1_0010;
            8'h26: decode_code = 5'b1_0011;
            8'h25: decode_code = 5'b1_0100;
            8'h2e: decode_code = 5'b1_0101;
            8'h36: decode_code = 5'b1_0110;
            8'h3d: decode_code = 5'b1_0111;
            8'h3e: decode_code = 5'b1_1000;
            8'h46: decode_code = 5'b1_1001;
            default: decode_code = 5'b0_0000; // valid=0, out=0
        endcase
    end
endfunction

wire [4:0] decoded = decode_code(code);
assign valid = decoded[4];
assign out = decoded[3:0];

endmodule