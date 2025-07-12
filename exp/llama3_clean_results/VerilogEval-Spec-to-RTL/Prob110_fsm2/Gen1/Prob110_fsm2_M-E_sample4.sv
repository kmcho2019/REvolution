module TopModule (
  input        clk,
  input        areset,
  input        j,
  input        k,
  output       out
);

// Current state
reg state;

// Assign output based on state
assign out = state;

// State transition logic
always_ff @(posedge clk or posedge areset) begin
  if (areset) begin
    state <= 1'b0;
  end else begin
    case ({state, j, k})
      3'b000, 3'b001, 3'b100: state <= 1'b0;
      3'b010: state <= 1'b1;
      3'b011, 3'b101, 3'b110, 3'b111: state <= 1'b1;
    endcase
  end
end

endmodule