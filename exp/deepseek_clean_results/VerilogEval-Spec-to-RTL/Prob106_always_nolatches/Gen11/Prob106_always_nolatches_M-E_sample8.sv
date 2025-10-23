module TopModule (
    input [15:0] scancode,
    output left,
    output down,
    output right,
    output up
);

    // Parallel comparison of all possible arrow key scancodes
    wire left_match  = (scancode == 16'he06b);
    wire down_match  = (scancode == 16'he072);
    wire right_match = (scancode == 16'he074);
    wire up_match    = (scancode == 16'he075);

    // Direct assignment of outputs
    assign left  = left_match;
    assign down  = down_match;
    assign right = right_match;
    assign up    = up_match;

endmodule