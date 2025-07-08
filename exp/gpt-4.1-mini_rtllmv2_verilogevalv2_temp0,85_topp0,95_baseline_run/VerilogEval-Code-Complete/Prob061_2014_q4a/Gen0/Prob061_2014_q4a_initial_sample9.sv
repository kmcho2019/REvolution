module TopModule (
  input clk,
  input w,
  input R,
  input E,
  input L,
  output reg Q
);
  
  always @(posedge clk) begin
    if (L)       // Load mode: load R into Q
      Q <= R;
    else if (E)  // Shift mode: shift in w
      Q <= w;
    else         // Hold current value
      Q <= Q;
  end

endmodule