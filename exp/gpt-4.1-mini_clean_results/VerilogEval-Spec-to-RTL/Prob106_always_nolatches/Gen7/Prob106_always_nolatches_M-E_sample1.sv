module TopModule (
    input  [15:0] scancode,
    output        left,
    output        down,
    output        right,
    output        up
);

    // One-hot vector for arrow keys:
    // bit 3 = left, bit 2 = down, bit 1 = right, bit 0 = up
    wire [3:0] arrow_decoded;

    assign arrow_decoded[3] = (scancode == 16'hE06B); // left arrow
    assign arrow_decoded[2] = (scancode == 16'hE072); // down arrow
    assign arrow_decoded[1] = (scancode == 16'hE074); // right arrow
    assign arrow_decoded[0] = (scancode == 16'hE075); // up arrow

    // Map one-hot bits to outputs
    assign left  = arrow_decoded[3];
    assign down  = arrow_decoded[2];
    assign right = arrow_decoded[1];
    assign up    = arrow_decoded[0];

endmodule