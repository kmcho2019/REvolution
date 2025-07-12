module TopModule(
    input  [7:0] code,
    output [3:0] out,
    output       valid
);

    // Combined decode function: returns {valid, digit}
    function [4:0] decode_scancode;
        input [7:0] scode;
        begin
            case(scode)
                8'h45: decode_scancode = {1'b1, 4'd0};
                8'h16: decode_scancode = {1'b1, 4'd1};
                8'h1E: decode_scancode = {1'b1, 4'd2};
                8'h26: decode_scancode = {1'b1, 4'd3};
                8'h25: decode_scancode = {1'b1, 4'd4};
                8'h2E: decode_scancode = {1'b1, 4'd5};
                8'h36: decode_scancode = {1'b1, 4'd6};
                8'h3D: decode_scancode = {1'b1, 4'd7};
                8'h3E: decode_scancode = {1'b1, 4'd8};
                8'h46: decode_scancode = {1'b1, 4'd9};
                default: decode_scancode = 5'b0; // valid=0, digit=0
            endcase
        end
    endfunction

    wire [4:0] decoded = decode_scancode(code);

    assign valid = decoded[4];
    assign out = decoded[3:0];

endmodule