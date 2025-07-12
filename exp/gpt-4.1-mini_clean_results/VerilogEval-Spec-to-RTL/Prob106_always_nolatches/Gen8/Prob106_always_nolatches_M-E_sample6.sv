module TopModule (
    input  [15:0] scancode,
    output        left,
    output        down,
    output        right,
    output        up
);

    wire [7:0] prefix = scancode[15:8];
    wire [7:0] keycode = scancode[7:0];

    wire is_e0 = (prefix == 8'hE0);

    assign left  = is_e0 && (keycode == 8'h6B);
    assign down  = is_e0 && (keycode == 8'h72);
    assign right = is_e0 && (keycode == 8'h74);
    assign up    = is_e0 && (keycode == 8'h75);

endmodule