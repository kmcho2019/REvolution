module TopModule (
    input  [15:0] scancode,
    output        left,
    output        down,
    output        right,
    output        up
);

    // Internal 4-bit wire representing the arrow outputs: {up, right, down, left}
    wire [3:0] arrow;

    // Decode scancode using case statement
    assign arrow = (scancode) ? (
                     (scancode == 16'hE06B) ? 4'b0001 :  // left
                     (scancode == 16'hE072) ? 4'b0100 :  // down
                     (scancode == 16'hE074) ? 4'b0010 :  // right
                     (scancode == 16'hE075) ? 4'b1000 :  // up
                     4'b0000
                   ) : 4'b0000;

    assign left  = arrow[0];
    assign right = arrow[1];
    assign down  = arrow[2];
    assign up    = arrow[3];

endmodule