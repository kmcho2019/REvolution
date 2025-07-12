module TopModule (
    input [15:0] scancode,
    output left,
    output down,
    output right,
    output up
);

    // Individual key detection
    wire left_detected  = (scancode == 16'he06b);
    wire down_detected  = (scancode == 16'he072);
    wire right_detected = (scancode == 16'he074);
    wire up_detected    = (scancode == 16'he075);

    // Priority encoder (left has highest priority)
    assign left  = left_detected;
    assign down  = down_detected & ~left_detected;
    assign right = right_detected & ~(left_detected | down_detected);
    assign up    = up_detected & ~(left_detected | down_detected | right_detected);

endmodule