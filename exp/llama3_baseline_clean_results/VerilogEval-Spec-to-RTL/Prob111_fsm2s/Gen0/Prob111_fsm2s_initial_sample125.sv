module TopModule(
  input clk,
  input reset,
  input j,
  input k,
  output out
);

// Define the states
parameter OFF = 1'b0;
parameter ON = 1'b1;

// Declare the current state and next state variables
reg current_state;
reg next_state;

// Output is a function of the current state
assign out = current_state;

// Sequential logic to update the current state
always @ (posedge clk) begin
  if (reset) begin
    current_state <= OFF;
  end else begin
    current_state <= next_state;
  end
end

// Combinational logic to determine the next state
always @ (*) begin
  case (current_state)
    OFF: begin
      if (j) begin
        next_state = ON;
      end else begin
        next_state = OFF;
      end
    end
    ON: begin
      if (k) begin
        next_state = OFF;
      end else begin
        next_state = ON;
      end
    end
    default: next_state = OFF;
  endcase
end

endmodule