module TopModule (
  input clk,
  input w,
  input R,
  input E,
  input L,
  output reg Q
);

  reg D;

  // D flip-flop to store the value
  always @(posedge clk) begin
    if (L) D <= R; // Load R into D when L is asserted
    else D <= (E) ? {Q, w} : {D[Q:$-1], D[Q]}; // Shift the data based on E
  end

  // Output Q from the flip-flop
  always @(*) begin
    Q = D[Q];
  end

endmodule