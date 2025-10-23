module TopModule (
    input  [15:0] scancode,
    output        left,
    output        down,
    output        right,
    output        up
);

    // Check that upper byte is 0xE0 prefix
    wire is_e0 = (scancode[15:8] == 8'hE0);

    assign left  = is_e0 && (scancode[7:0] == 8'h6B);
    assign down  = is_e0 && (scancode[7:0] == 8'h72);
    assign right = is_e0 && (scancode[7:0] == 8'h74);
    assign up    = is_e0 && (scancode[7:0] == 8'h75);

endmodule