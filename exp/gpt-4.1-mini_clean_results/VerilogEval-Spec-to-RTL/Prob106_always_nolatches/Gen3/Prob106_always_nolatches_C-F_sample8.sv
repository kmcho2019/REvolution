module TopModule (
    input  [15:0] scancode,
    output        left,
    output        down,
    output        right,
    output        up
);

    // Decode the scancode using a single combinational case statement
    wire left_signal;
    wire down_signal;
    wire right_signal;
    wire up_signal;

    assign {left_signal, down_signal, right_signal, up_signal} = (scancode == 16'he06b) ? 4'b1000 : // left
                                                               (scancode == 16'he072) ? 4'b0100 : // down
                                                               (scancode == 16'he074) ? 4'b0010 : // right
                                                               (scancode == 16'he075) ? 4'b0001 : // up
                                                                                       4'b0000;  // none

    assign left  = left_signal;
    assign down  = down_signal;
    assign right = right_signal;
    assign up    = up_signal;

endmodule