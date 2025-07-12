module TopModule(
    input [2:0] y,
    input w,
    output Y1
);

    assign Y1 = y[1];

    // next-state logic for y[1]
    wire next_y1;
    assign next_y1 = (y == 3'b001 && w) || // B and w=1
                     (y == 3'b100 && w) || // C and w=1
                     (y == 3'b101 && w) || // D and w=1
                     (y == 3'b110)        || // E
                     (y == 3'b111 && w);   // F and w=1

endmodule