module TopModule (
  input clk,    // Clock input
  input w,      // Input data to the first stage
  input R,      // Value to load
  input E,      // Shift enable signal
  input L,      // Load signal
  output reg Q  // Output of the stage
);
  
  reg D;      // Input to the D flip-flop
  
  always @ (posedge clk) begin
    // Control logic for loading or shifting
    if (L) begin  // Load stage
      D <= R;
    end else if (E) begin  // Shift stage
      D <= Q;  // Shift in the previous stage's value
    end else begin
      D <= w;  // Load the input data
    end
  end
  
  // D flip-flop to store the value
  always @ (posedge clk) begin
    Q <= D;
  end
endmodule