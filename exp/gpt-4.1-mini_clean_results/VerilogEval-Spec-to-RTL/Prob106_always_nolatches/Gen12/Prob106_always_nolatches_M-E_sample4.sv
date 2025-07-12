module TopModule (
    input  [15:0] scancode,
    output        left,
    output        down,
    output        right,
    output        up
);

    wire is_E0 = (scancode[15:8] == 8'hE0);

    assign left  = is_E0 && (scancode[7:0] == 8'h6B);
    assign down  = is_E0 && (scancode[7:0] == 8'h72);
    assign right = is_E0 && (scancode[7:0] == 8'h74);
    assign up    = is_E0 && (scancode[7:0] == 8'h75);

endmodule