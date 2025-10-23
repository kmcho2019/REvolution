module TopModule(
  input clk,
  input areset,
  input j,
  input k,
  output reg out
);

// Define states
parameter STATE_OFF = 1'b0;
parameter STATE_ON  = 1'b1;

// Declare current and next state
reg current_state;
reg next_state;

// Determine next state
always @(*) begin
  case (current_state)
    STATE_OFF: begin
      if (j) begin
        next_state = STATE_ON;
      end else begin
        next_state = STATE_OFF;
      end
    end
    STATE_ON: begin
      if (k) begin
        next_state = STATE_OFF;
      end else begin
        next_state = STATE_ON;
      end
    end
  endcase
end

// Update current state on clock edge
always @(posedge clk or posedge areset) begin
  if (areset) begin
    current_state <= STATE_OFF;
  end else begin
    current_state <= next_state;
  end
end

// Determine output
always @(*) begin
  case (current_state)
    STATE_OFF: out = 1'b0;
    STATE_ON:  out = 1'b1;
  endcase
end

endmodule