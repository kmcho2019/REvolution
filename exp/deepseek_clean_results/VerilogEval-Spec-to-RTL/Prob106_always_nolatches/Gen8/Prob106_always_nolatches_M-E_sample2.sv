module TopModule (
    input [15:0] scancode,
    output left,
    output down,
    output right,
    output up
);

    // Check if it's an extended key (prefix E0)
    wire is_extended = (scancode[15:8] == 8'he0);
    
    // Priority encoder for arrow keys (left has highest priority)
    assign left  = is_extended & (scancode[7:0] == 8'h6b);
    assign down  = is_extended & (scancode[7:0] == 8'h72) & ~left;
    assign right = is_extended & (scancode[7:0] == 8'h74) & ~left & ~down;
    assign up    = is_extended & (scancode[7:0] == 8'h75) & ~left & ~down & ~right;

endmodule