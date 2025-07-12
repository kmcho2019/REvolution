module TopModule (
    input  [15:0] scancode,
    output       left,
    output       down,
    output       right,
    output       up
);

    // Define a function that decodes the scancode into a 4-bit code:
    // bit 3 = up, bit 2 = right, bit 1 = down, bit 0 = left
    function [3:0] decode_arrow;
        input [15:0] code;
        begin
            decode_arrow = 4'b0000; // default none
            if (code[15:8] == 8'hE0) begin
                case (code[7:0])
                    8'h6B: decode_arrow = 4'b0001; // left
                    8'h72: decode_arrow = 4'b0010; // down
                    8'h74: decode_arrow = 4'b0100; // right
                    8'h75: decode_arrow = 4'b1000; // up
                    default: decode_arrow = 4'b0000;
                endcase
            end
        end
    endfunction

    wire [3:0] arrow_bits;
    assign arrow_bits = decode_arrow(scancode);

    assign left  = arrow_bits[0];
    assign down  = arrow_bits[1];
    assign right = arrow_bits[2];
    assign up    = arrow_bits[3];

endmodule