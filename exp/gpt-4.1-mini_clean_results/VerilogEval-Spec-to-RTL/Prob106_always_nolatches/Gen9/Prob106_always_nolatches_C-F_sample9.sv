module TopModule (
    input  [15:0] scancode,
    output        left,
    output        down,
    output        right,
    output        up
);

    wire prefix_ok = (scancode[15:8] == 8'hE0);
    wire [7:0] keycode = scancode[7:0];

    assign left  = prefix_ok && (keycode == 8'h6B);
    assign down  = prefix_ok && (keycode == 8'h72);
    assign right = prefix_ok && (keycode == 8'h74);
    assign up    = prefix_ok && (keycode == 8'h75);

endmodule