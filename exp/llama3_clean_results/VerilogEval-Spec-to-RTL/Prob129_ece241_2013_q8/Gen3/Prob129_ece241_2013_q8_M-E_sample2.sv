module TopModule (
  input clk,
  input aresetn,
  input x,
  output z
);

reg [2:0] shift_reg; // 3-bit shift register to track input history
reg state; // single-bit state register

always @ (posedge clk or negedge aresetn) begin
  if (!aresetn) begin // async reset
    shift_reg <= 3'b000;
    state <= 1'b0;
  end else begin
    // Shift in the new input value
    shift_reg <= {shift_reg[1:0], x};
    
    // State machine: assert state when the correct sequence is detected
    if (shift_reg == 3'b101) begin
      state <= 1'b1;
    end else begin
      state <= 1'b0;
    end
  end
end

// Output z is asserted when the state is '1'
assign z = state;

endmodule