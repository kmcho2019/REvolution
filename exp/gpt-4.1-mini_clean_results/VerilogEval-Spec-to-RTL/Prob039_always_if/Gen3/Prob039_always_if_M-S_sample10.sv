module TopModule(
    input  a,
    input  b,
    input  sel_b1,
    input  sel_b2,
    output reg out_always,
    output out_assign
);

  // Use the always block to drive out_always
  always @(*) begin
    if (sel_b1 & sel_b2)
      out_always <= b;
    else
      out_always <= a;
  end

  // Connect out_assign directly to out_always to avoid duplicate mux logic
  assign out_assign = out_always;

endmodule