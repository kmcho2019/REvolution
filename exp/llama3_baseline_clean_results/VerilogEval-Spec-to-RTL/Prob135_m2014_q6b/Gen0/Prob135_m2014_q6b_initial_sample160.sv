module TopModule(
    input [2:0] y,
    input w,
    output Y1
);

// Next-state logic for y[1]
assign Y1 = (y == 3'b001 && w) ||  // B and w = 1
             (y == 3'b100 && w) ||  // C and w = 1
             (y == 3'b101 && ~w) || // D and w = 0
             (y == 3'b101 && w) ||  // D and w = 1
             (y == 3'b110 && ~w) || // E and w = 0
             (y == 3'b110 && w) ||  // E and w = 1
             (y == 3'b111 && w);    // F and w = 1

endmodule