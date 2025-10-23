module TopModule (
    input  [7:0] code,
    output [3:0] out,
    output       valid
);

// Function returns {valid, digit}, valid=1 if code recognized, else 0
function [4:0] decode_code;
    input [7:0] c;
    begin
        // Default: invalid code
        decode_code = 5'b0_0000;
        case (c)
            8'h45: decode_code = {1'b1, 4'd0};
            8'h16: decode_code = {1'b1, 4'd1};
            8'h1e: decode_code = {1'b1, 4'd2};
            8'h26: decode_code = {1'b1, 4'd3};
            8'h25: decode_code = {1'b1, 4'd4};
            8'h2e: decode_code = {1'b1, 4'd5};
            8'h36: decode_code = {1'b1, 4'd6};
            8'h3d: decode_code = {1'b1, 4'd7};
            8'h3e: decode_code = {1'b1, 4'd8};
            8'h46: decode_code = {1'b1, 4'd9};
        endcase
    end
endfunction

wire [4:0] decoded = decode_code(code);

assign valid = decoded[4];
assign out   = decoded[3:0];

endmodule