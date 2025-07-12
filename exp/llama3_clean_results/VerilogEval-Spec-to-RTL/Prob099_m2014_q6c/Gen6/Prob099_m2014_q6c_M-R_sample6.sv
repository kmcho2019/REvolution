module TopModule(y, w, Y1, Y3);
  input [5:0] y;
  input w;
  output Y1;
  output Y3;

  // Next-state logic for Y1 (state A)
  assign Y1 = (~w & y[0]) | (w & y[3]);

  // Next-state logic for Y2 is not required as per the problem statement
  // Next-state logic for Y3 (state C)
  assign Y3 = (~w & y[1]);

  // The state machine transitions are implicitly handled by the assign statements
  // No need for an always block or explicit case statements

endmodule