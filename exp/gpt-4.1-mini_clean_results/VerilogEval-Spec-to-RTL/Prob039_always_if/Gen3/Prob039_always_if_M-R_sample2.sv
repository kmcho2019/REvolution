module TopModule(
    input  a,
    input  b,
    input  sel_b1,
    input  sel_b2,
    output reg out_assign,
    output reg out_always
);

  // Procedural implementation using ternary operator inside always block
  always @(*) begin
    out_assign = (sel_b1 & sel_b2) ? b : a;
  end

  // Procedural implementation with always block using if-else statement
  always @(*) begin
    if (sel_b1 & sel_b2)
      out_always = b;
    else
      out_always = a;
  end

endmodule