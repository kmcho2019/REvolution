module TopModule(
    input  [7:0] code,
    output [3:0] out,
    output valid
);

function [3:0] decode_code;
    input [7:0] c;
    begin
        case (c)
            8'h45: decode_code = 4'd0;
            8'h16: decode_code = 4'd1;
            8'h1e: decode_code = 4'd2;
            8'h26: decode_code = 4'd3;
            8'h25: decode_code = 4'd4;
            8'h2e: decode_code = 4'd5;
            8'h36: decode_code = 4'd6;
            8'h3d: decode_code = 4'd7;
            8'h3e: decode_code = 4'd8;
            8'h46: decode_code = 4'd9;
            default: decode_code = 4'b1111; // sentinel for no match
        endcase
    end
endfunction

wire [3:0] decoded_out = decode_code(code);
assign out = (decoded_out == 4'b1111) ? 4'd0 : decoded_out;
assign valid = (decoded_out != 4'b1111);

endmodule