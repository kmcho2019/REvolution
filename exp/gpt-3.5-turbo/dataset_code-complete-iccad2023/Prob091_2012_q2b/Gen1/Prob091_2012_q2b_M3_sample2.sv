module TopModule (
  input [5:0] y,
  input w,
  output Y1,
  output Y3
);

assign Y1 = (y[5] & !y[4] & !y[3] & y[2] & !y[1] & !y[0]) |  // F to C
            (!y[5] & !y[4] & y[3] & !y[2] & !y[1] & !y[0]);   // E to E
assign Y3 = (!y[5] & !y[4] & y[3] & !y[2] & !y[1] & !y[0]) |  // C to E
            (y[5] & !y[4] & !y[3] & y[2] & !y[1] & !y[0]);     // F to C

endmodule