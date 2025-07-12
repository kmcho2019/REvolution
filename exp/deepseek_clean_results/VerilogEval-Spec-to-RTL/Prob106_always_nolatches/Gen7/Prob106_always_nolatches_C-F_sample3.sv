module TopModule (
    input [15:0] scancode,
    output left,
    output down,
    output right,
    output up
);

    // Internal signals for each arrow key
    wire left_int, down_int, right_int, up_int;

    // Check if extended key (0xE0 prefix)
    wire is_extended = (scancode[15:8] == 8'hE0);

    // Decode lower byte only if extended key
    assign left_int  = is_extended & (scancode[7:0] == 8'h6B);
    assign down_int  = is_extended & (scancode[7:0] == 8'h72);
    assign right_int = is_extended & (scancode[7:0] == 8'h74);
    assign up_int    = is_extended & (scancode[7:0] == 8'h75);

    // Final outputs with default values
    assign left  = left_int;
    assign down  = down_int;
    assign right = right_int;
    assign up    = up_int;

endmodule