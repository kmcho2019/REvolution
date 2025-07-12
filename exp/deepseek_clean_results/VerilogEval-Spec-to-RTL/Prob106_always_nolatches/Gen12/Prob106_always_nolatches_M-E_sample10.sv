module TopModule (
    input [15:0] scancode,
    output left,
    output down,
    output right,
    output up
);

    // Left arrow detection (0xE06B)
    assign left = ~|(scancode ^ 16'he06b);
    
    // Down arrow detection (0xE072)
    assign down = ~|(scancode ^ 16'he072);
    
    // Right arrow detection (0xE074)
    assign right = ~|(scancode ^ 16'he074);
    
    // Up arrow detection (0xE075)
    assign up = ~|(scancode ^ 16'he075);

endmodule