module TopModule (
    input  [15:0] scancode,
    output        left,
    output        down,
    output        right,
    output        up
);

    wire e0_prefix = (scancode[15:8] == 8'hE0);

    assign left  = e0_prefix && (scancode[7:0] == 8'h6B);
    assign down  = e0_prefix && (scancode[7:0] == 8'h72);
    assign right = e0_prefix && (scancode[7:0] == 8'h74);
    assign up    = e0_prefix && (scancode[7:0] == 8'h75);

endmodule