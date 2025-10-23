module TopModule (
    input [15:0] scancode,
    output left,
    output down,
    output right,
    output up
);

    // Left arrow: E0 6B
    assign left = (scancode[15:8] == 8'hE0) && (scancode[7:0] == 8'h6B);
    
    // Down arrow: E0 72
    assign down = (scancode[15:8] == 8'hE0) && (scancode[7:0] == 8'h72);
    
    // Right arrow: E0 74
    assign right = (scancode[15:8] == 8'hE0) && (scancode[7:0] == 8'h74);
    
    // Up arrow: E0 75
    assign up = (scancode[15:8] == 8'hE0) && (scancode[7:0] == 8'h75);

endmodule