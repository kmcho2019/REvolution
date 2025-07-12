module TopModule (
    input [15:0] scancode,
    output left,
    output down,
    output right,
    output up
);

    // Check for extended key prefix first (power optimization)
    wire is_extended = (scancode[15:8] == 8'he0);
    
    // Parallel comparisons for specific arrow keys (performance optimization)
    assign left  = is_extended & (scancode[7:0] == 8'h6b);
    assign down  = is_extended & (scancode[7:0] == 8'h72);
    assign right = is_extended & (scancode[7:0] == 8'h74);
    assign up    = is_extended & (scancode[7:0] == 8'h75);

endmodule