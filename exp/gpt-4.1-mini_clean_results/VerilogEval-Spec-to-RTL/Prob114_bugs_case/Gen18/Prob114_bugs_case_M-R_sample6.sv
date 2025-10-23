module TopModule(
    input  [7:0] code,
    output [3:0] out,
    output valid
);

function [3:0] decode;
    input [7:0] c;
    begin
        case (c)
            8'h45: decode = 4'd0;
            8'h16: decode = 4'd1;
            8'h1e: decode = 4'd2;
            8'h26: decode = 4'd3;
            8'h25: decode = 4'd4;
            8'h2e: decode = 4'd5;
            8'h36: decode = 4'd6;
            8'h3d: decode = 4'd7;
            8'h3e: decode = 4'd8;
            8'h46: decode = 4'd9;
            default: decode = 4'hF; // invalid sentinel
        endcase
    end
endfunction

wire [3:0] decoded = decode(code);

assign valid = (decoded != 4'hF);
assign out = valid ? decoded : 4'd0;

endmodule