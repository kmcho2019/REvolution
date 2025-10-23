module TopModule (
  input  clk,
  input  reset,
  input  j,
  input  k,
  output out
);

  reg [0:0] state; // 1-bit register for the state

  // Output is determined by the state
  assign out = state;

  // State machine transition logic
  always @(posedge clk) begin
    if (reset) begin // active-high synchronous reset to state OFF
      state <= 1'b0;
    end else begin
      case (state)
        1'b0: state <= j ? 1'b1 : 1'b0; // OFF state: if j=1, go to ON, else stay in OFF
        1'b1: state <= ~k ? 1'b1 : 1'b0; // ON state: if k=0, stay in ON, else go to OFF
      endcase
    end
  end

endmodule