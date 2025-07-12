module TopModule(
  input  clk,
  input  resetn,
  input  [2:0] r,
  output [2:0] g
);

reg [1:0] state, next_state;

// State Table
always @(*) begin
  case(state)
    2'b00: // State A
      if (r[0]) begin
        next_state = 2'b01; // State B
      end else if (r[1]) begin
        next_state = 2'b10; // State C
      end else if (r[2]) begin
        next_state = 2'b00; // State A
      end else begin
        next_state = 2'b00; // State A
      end
    2'b01: // State B
      if (r[0]) begin
        next_state = 2'b01; // State B
      end else begin
        next_state = 2'b00; // State A
      end
    2'b10: // State C
      if (r[1]) begin
        next_state = 2'b10; // State C
      end else begin
        next_state = 2'b00; // State A
      end
    default: next_state = 2'b00;
  endcase
end

// State Flip-Flops
always @(posedge clk) begin
  if (~resetn) begin
    state <= 2'b00;
  end else begin
    state <= next_state;
  end
end

// Output Logic
assign g[0] = (state == 2'b01);
assign g[1] = (state == 2'b10);
assign g[2] = 1'b0; // g[2] is never set to 1

endmodule