module TopModule (
    input  [15:0] scancode,
    output        left,
    output        down,
    output        right,
    output        up
);

    wire [3:0] arrows; // bit3=left, bit2=down, bit1=right, bit0=up

    assign arrows = (scancode[15:8] == 8'hE0) ? 
                    (scancode[7:0] == 8'h6B ? 4'b1000 : // left
                     scancode[7:0] == 8'h72 ? 4'b0100 : // down
                     scancode[7:0] == 8'h74 ? 4'b0010 : // right
                     scancode[7:0] == 8'h75 ? 4'b0001 : // up
                     4'b0000)
                    : 4'b0000;

    assign left  = arrows[3];
    assign down  = arrows[2];
    assign right = arrows[1];
    assign up    = arrows[0];

endmodule