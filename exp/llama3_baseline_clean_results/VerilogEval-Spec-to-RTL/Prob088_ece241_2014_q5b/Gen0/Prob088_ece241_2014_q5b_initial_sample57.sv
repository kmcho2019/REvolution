module TopModule(
  input  clk,
  input  areset,
  input  x,
  output z
);

reg [1:0] state, next_state;
wire [1:0] curr_state;

// One-hot encoding: A = 2'b01, B = 2'b10
assign curr_state = state;

always @(*) begin
  case (curr_state)
    2'b01: begin // State A
      if (~x) next_state = 2'b01; // A --x=0 (z=0)--> A
      else    next_state = 2'b10; // A --x=1 (z=1)--> B
    end
    2'b10: begin // State B
      if (~x) next_state = 2'b10; // B --x=0 (z=1)--> B
      else    next_state = 2'b10; // B --x=1 (z=0)--> B
    end
    default: next_state = 2'b01; // Invalid state, reset to A
  endcase
end

always @ (posedge clk or posedge areset) begin
  if (areset) begin
    state <= 2'b01; // Reset to state A
  end else begin
    state <= next_state;
  end
end

always @(*) begin
  case (curr_state)
    2'b01: begin // State A
      if (~x) z = 1'b0; // A --x=0 (z=0)--> A
      else    z = 1'b1; // A --x=1 (z=1)--> B
    end
    2'b10: begin // State B
      if (~x) z = 1'b1; // B --x=0 (z=1)--> B
      else    z = 1'b0; // B --x=1 (z=0)--> B
    end
    default: z = 1'b0; // Invalid state, default output
  endcase
end

endmodule