module TopModule(
    input  a,
    input  b,
    input  sel_b1,
    input  sel_b2,
    output out_assign,
    output reg out_always
);

  wire selected;

  // Single continuous assignment for mux logic
  assign selected = (sel_b1 & sel_b2) ? b : a;

  // Procedural block just assigns the wire value to the reg output
  always @(*) begin
    out_always = selected;
  end

  // Direct assignment from the selected wire
  assign out_assign = selected;

endmodule