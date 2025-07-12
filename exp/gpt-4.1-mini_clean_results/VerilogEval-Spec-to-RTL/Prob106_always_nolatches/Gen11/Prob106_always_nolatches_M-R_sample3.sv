module TopModule (
    input  [15:0] scancode,
    output        left,
    output        down,
    output        right,
    output        up
);

    // Check if the prefix byte is 0xE0
    wire prefix_match = (scancode[15:8] == 8'hE0);

    assign left  = prefix_match && (scancode[7:0] == 8'h6B) ? 1'b1 : 1'b0;
    assign down  = prefix_match && (scancode[7:0] == 8'h72) ? 1'b1 : 1'b0;
    assign right = prefix_match && (scancode[7:0] == 8'h74) ? 1'b1 : 1'b0;
    assign up    = prefix_match && (scancode[7:0] == 8'h75) ? 1'b1 : 1'b0;

endmodule