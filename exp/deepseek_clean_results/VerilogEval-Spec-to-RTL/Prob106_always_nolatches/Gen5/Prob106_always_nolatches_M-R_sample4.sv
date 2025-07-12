module TopModule (
    input [15:0] scancode,
    output left,
    output down,
    output right,
    output up
);

    // Left arrow: E0 6B
    assign left = (scancode == 16'he06b);
    
    // Down arrow: E0 72
    assign down = (scancode == 16'he072);
    
    // Right arrow: E0 74
    assign right = (scancode == 16'he074);
    
    // Up arrow: E0 75
    assign up = (scancode == 16'he075);

endmodule