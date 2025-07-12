module TopModule(clk, j, k, Q);
  input clk;
  input j;
  input k;
  output Q;
  reg Q; // Declare Q as a reg to hold the state

  always @(posedge clk) // Update Q at the positive edge of the clock
    begin
      case({j, k}) // Use a case statement to implement the truth table
        2'b00: Q <= Q; // Qold when J=0, K=0
        2'b01: Q <= 1'b0; // Q = 0 when J=0, K=1
        2'b10: Q <= 1'b1; // Q = 1 when J=1, K=0
        2'b11: Q <= ~Q; // Q = ~Qold when J=1, K=1
      endcase
    end
endmodule