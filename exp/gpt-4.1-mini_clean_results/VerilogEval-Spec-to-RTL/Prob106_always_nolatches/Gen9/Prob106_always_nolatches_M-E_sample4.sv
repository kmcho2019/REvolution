module TopModule (
    input  [15:0] scancode,
    output        left,
    output        down,
    output        right,
    output        up
);

    wire high_byte_is_e0;
    wire low_byte_left;
    wire low_byte_down;
    wire low_byte_right;
    wire low_byte_up;

    assign high_byte_is_e0 = (scancode[15:8] == 8'hE0);
    assign low_byte_left   = (scancode[7:0]  == 8'h6B);
    assign low_byte_down   = (scancode[7:0]  == 8'h72);
    assign low_byte_right  = (scancode[7:0]  == 8'h74);
    assign low_byte_up     = (scancode[7:0]  == 8'h75);

    assign left  = high_byte_is_e0 & low_byte_left;
    assign down  = high_byte_is_e0 & low_byte_down;
    assign right = high_byte_is_e0 & low_byte_right;
    assign up    = high_byte_is_e0 & low_byte_up;

endmodule