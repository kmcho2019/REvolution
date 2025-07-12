module TopModule (
    input [15:0] scancode,
    output left,
    output down,
    output right,
    output up
);

    // PS/2 scancode decoding for arrow keys
    // Extended keys have 0xE0 prefix followed by key code
    // Outputs are encoded as one-hot: {left, down, right, up}
    wire [3:0] arrow_keys;
    assign arrow_keys = (scancode[15:8] == 8'hE0) ? 
        (scancode[7:0] == 8'h6B ? 4'b1000 :  // Left arrow
         scancode[7:0] == 8'h72 ? 4'b0100 :  // Down arrow
         scancode[7:0] == 8'h74 ? 4'b0010 :  // Right arrow
         scancode[7:0] == 8'h75 ? 4'b0001 :  // Up arrow
         4'b0000) : 4'b0000;

    assign {left, down, right, up} = arrow_keys;

endmodule