module TopModule (
    input [15:0] scancode,
    output left,
    output down,
    output right,
    output up
);

    // Parallel comparators for each arrow key
    wire left_match  = (scancode == 16'he06b);
    wire down_match  = (scancode == 16'he072);
    wire right_match = (scancode == 16'he074);
    wire up_match    = (scancode == 16'he075);

    // Priority encoder (left has highest priority)
    assign left  = left_match;
    assign down  = down_match & ~left_match;
    assign right = right_match & ~(left_match | down_match);
    assign up    = up_match & ~(left_match | down_match | right_match);

endmodule