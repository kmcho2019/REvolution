module TopModule (
    input [15:0] scancode,
    output left,
    output down,
    output right,
    output up
);

    // PS/2 scancode format: E0XX where XX is key code
    wire is_extended = (scancode[15:8] == 8'hE0);
    wire [7:0] keycode = scancode[7:0];

    // Direct mapping of arrow keys with one-hot encoding
    assign left  = is_extended & (keycode == 8'h6B);
    assign down  = is_extended & (keycode == 8'h72);
    assign right = is_extended & (keycode == 8'h74);
    assign up    = is_extended & (keycode == 8'h75);

endmodule