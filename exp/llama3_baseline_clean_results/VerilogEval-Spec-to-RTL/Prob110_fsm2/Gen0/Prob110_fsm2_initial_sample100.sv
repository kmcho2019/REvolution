module TopModule (
  input  clk,
  input  areset,
  input  j,
  input  k,
  output out
);

// Define the states
parameter OFF = 1'b0, ON = 1'b1;

// Declare the current state and next state
reg current_state, next_state;

// Asynchronous reset
always @(posedge areset or posedge clk) begin
  if (areset) begin
    current_state <= OFF;
  end else begin
    current_state <= next_state;
  end
end

// Determine the next state
always @(*) begin
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

// Determine the output
always @(*) begin
  case (current_state)
    OFF: out = 1'b0;
    ON:  out = 1'b1;
    default: out = 1'b0;
  endcase
end

endmodule