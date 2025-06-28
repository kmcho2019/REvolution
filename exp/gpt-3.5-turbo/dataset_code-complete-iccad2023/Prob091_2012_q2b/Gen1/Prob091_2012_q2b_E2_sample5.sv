module TopModule (
  input [5:0] y,
  input w,
  output Y1,
  output Y3
);
  
  // Determine the next state based on the current state and input w for Y1 and Y3
  always @*
  begin
    // Determine Y1 based on the state transitions from B to C, C to E, and F to C
    Y1 = ((y[4] & !y[3]) | (y[3] & y[2]) | (y[5] & !y[4]));
    
    // Determine Y3 based on the state transitions from C to E and F to C
    Y3 = ((y[3] & y[2]) | (y[5] & !y[4]));
  end

endmodule