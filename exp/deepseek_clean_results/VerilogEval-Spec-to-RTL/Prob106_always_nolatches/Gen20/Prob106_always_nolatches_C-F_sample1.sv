module TopModule (
    input [15:0] scancode,
    output left,
    output down,
    output right,
    output up
);

    // Direct parallel comparisons using XOR-NOR pattern
    assign left  = (scancode == 16'he06b);  // Left arrow
    assign down  = (scancode == 16'he072);  // Down arrow
    assign right = (scancode == 16'he074);  // Right arrow
    assign up    = (scancode == 16'he075);  // Up arrow

endmodule