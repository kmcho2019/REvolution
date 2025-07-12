module TopModule (
    input  [15:0] scancode,
    output        left,
    output        down,
    output        right,
    output        up
);

    // Each output is asserted by directly comparing the scancode input with the known arrow key values.
    assign left  = (scancode == 16'he06b);
    assign down  = (scancode == 16'he072);
    assign right = (scancode == 16'he074);
    assign up    = (scancode == 16'he075);

endmodule