module TopModule (
    input [15:0] scancode,
    output left,
    output down,
    output right,
    output up
);

    // Check if first byte is 0xE0 and second byte matches arrow key codes
    assign left  = (scancode == 16'he06b);
    assign down  = (scancode == 16'he072);
    assign right = (scancode == 16'he074);
    assign up    = (scancode == 16'he075);

endmodule