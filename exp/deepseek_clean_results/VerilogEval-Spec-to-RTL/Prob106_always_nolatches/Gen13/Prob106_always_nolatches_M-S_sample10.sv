module TopModule (
    input [15:0] scancode,
    output left,
    output down,
    output right,
    output up
);

    // Direct mapping of full 16-bit scancodes to arrow key outputs
    assign {left, down, right, up} = 
        (scancode == 16'he06b) ? 4'b1000 :  // left
        (scancode == 16'he072) ? 4'b0100 :  // down
        (scancode == 16'he074) ? 4'b0010 :  // right
        (scancode == 16'he075) ? 4'b0001 :  // up
                                 4'b0000;   // none

endmodule