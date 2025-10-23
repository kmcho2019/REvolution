module TopModule (
    input  [15:0] scancode,
    output        left,
    output        down,
    output        right,
    output        up
);

    // Directly assign outputs by comparing scancode to each arrow key code
    assign left  = (scancode == 16'hE06B);
    assign down  = (scancode == 16'hE072);
    assign right = (scancode == 16'hE074);
    assign up    = (scancode == 16'hE075);

endmodule