module TopModule(
  input clk,
  input areset,
  input in,
  output out
);

reg [0:0] state; // Two states, A and B
parameter B = 1'b1, A = 1'b0;

always @(*) begin // Combinational logic for state transitions
  case (state)
    B: if (in) out = 1'b1; else out = 1'b1;
    A: if (in) out = 1'b0; else out = 1'b1;
  endcase
end

always @(posedge clk or posedge areset) begin // Sequential logic for state updates
  if (areset) begin // Asynchronous reset
    state <= B;
  end else begin
    case (state)
      B: if (in) state <= B; else state <= A;
      A: if (in) state <= A; else state <= B;
    endcase
  end
end

endmodule