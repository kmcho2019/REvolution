module TopModule (
    input [15:0] scancode,
    output left,
    output down,
    output right,
    output up
);

    // First check if scancode has the arrow key prefix (0xe0)
    wire is_arrow = (scancode[15:8] == 8'he0);

    // Assign outputs based on scancode matches, checking both prefix and suffix
    assign left  = is_arrow & (scancode[7:0] == 8'h6b);
    assign down  = is_arrow & (scancode[7:0] == 8'h72);
    assign right = is_arrow & (scancode[7:0] == 8'h74);
    assign up    = is_arrow & (scancode[7:0] == 8'h75);

endmodule