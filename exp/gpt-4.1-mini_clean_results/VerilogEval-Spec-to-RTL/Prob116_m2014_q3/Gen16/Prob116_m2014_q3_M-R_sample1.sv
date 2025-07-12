module TopModule (
    input  [3:0] x,  // x = {x4, x3, x2, x1} with x[3]=x4, x[2]=x3, x[1]=x2, x[0]=x1
    output       f
);

    // Extract bits directly without Gray-to-binary conversion
    wire [1:0] row = x[3:2]; // x4x3
    wire [1:0] col = x[1:0]; // x2x1

    // Flatten address as {row, col}
    wire [3:0] addr = {row, col};

    // Combinational function to decode addr into f based on the given K-map
    function logic decode_f(input [3:0] addr);
        begin
            case(addr)
                // row=00 (x4x3=00)
                4'b0000: decode_f = 1'b0; // col=00 (d -> 0)
                4'b0001: decode_f = 1'b0; // col=01 (0)
                4'b0011: decode_f = 1'b0; // col=11 (d -> 0)
                4'b0010: decode_f = 1'b0; // col=10 (d -> 0)

                // row=01 (x4x3=01)
                4'b0100: decode_f = 1'b0; // col=00 (0)
                4'b0101: decode_f = 1'b0; // col=01 (d -> 0)
                4'b0110: decode_f = 1'b1; // col=10 (1)
                4'b0111: decode_f = 1'b0; // col=11 (0)

                // row=10 (x4x3=10)
                4'b1000: decode_f = 1'b1; // col=00 (1)
                4'b1001: decode_f = 1'b1; // col=01 (1)
                4'b1010: decode_f = 1'b0; // col=10 (0)
                4'b1011: decode_f = 1'b0; // col=11 (d -> 0)

                // row=11 (x4x3=11)
                4'b1100: decode_f = 1'b1; // col=00 (1)
                4'b1101: decode_f = 1'b1; // col=01 (1)
                4'b1110: decode_f = 1'b0; // col=10 (d -> 0)
                4'b1111: decode_f = 1'b0; // col=11 (d -> 0)

                default: decode_f = 1'b0;
            endcase
        end
    endfunction

    // Continuous assignment using the decode function
    assign f = decode_f(addr);

endmodule