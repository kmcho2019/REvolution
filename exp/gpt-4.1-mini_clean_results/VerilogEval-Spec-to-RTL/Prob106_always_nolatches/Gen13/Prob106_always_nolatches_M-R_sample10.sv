module TopModule (
    input  [15:0] scancode,
    output        left,
    output        down,
    output        right,
    output        up
);

    wire high_byte_e0 = (scancode[15:8] == 8'hE0);

    assign left  = high_byte_e0 && (scancode[7:0] == 8'h6B);
    assign down  = high_byte_e0 && (scancode[7:0] == 8'h72);
    assign right = high_byte_e0 && (scancode[7:0] == 8'h74);
    assign up    = high_byte_e0 && (scancode[7:0] == 8'h75);

endmodule