module TopModule (
    input [15:0] scancode,
    output left,
    output down,
    output right,
    output up
);

    // Direct continuous assignments for each arrow key
    // Each output is high only when the full scancode matches exactly
    assign left  = (scancode == 16'he06b);
    assign down  = (scancode == 16'he072);
    assign right = (scancode == 16'he074);
    assign up    = (scancode == 16'he075);

endmodule