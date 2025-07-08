module TopModule (
  input clk,
  input in,
  input areset,
  output out
);

  // State encoding
  parameter A = 1'b0;
  parameter B = 1'b1;
  
  reg state;
  
  always @(posedge clk or posedge areset) begin
    if (areset) begin
      state <= B;  // Asynchronous reset to state B
    end else begin
      case (state)
        A: state <= in ? A : B;  // A stays on 1, goes to B on 0
        B: state <= in ? B : A;  // B stays on 1, goes to A on 0
      endcase
    end
  end
  
  assign out = state;  // Output is current state (0 for A, 1 for B)

endmodule