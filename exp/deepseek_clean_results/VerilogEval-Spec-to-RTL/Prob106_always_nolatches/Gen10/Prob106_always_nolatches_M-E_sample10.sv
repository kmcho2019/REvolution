module TopModule (
    input [15:0] scancode,
    output left,
    output down,
    output right,
    output up
);

    // Extended key prefix check (shared for all outputs)
    wire is_extended = (scancode[15:8] == 8'he0);

    // Parallel independent comparisons for each arrow key
    assign left  = is_extended & (scancode[7:0] == 8'h6b);
    assign down  = is_extended & (scancode[7:0] == 8'h72);
    assign right = is_extended & (scancode[7:0] == 8'h74);
    assign up    = is_extended & (scancode[7:0] == 8'h75);

endmodule