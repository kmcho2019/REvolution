module TopModule (
  input        clk,
  input        areset,
  input        j,
  input        k,
  output logic out
);

// Define states
typedef enum logic [0:0] {OFF, ON} state_t;

// Current and next state
state_t current_state, next_state;

// State transition logic
always_comb begin
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
  endcase
end

// Update current state and output
always_ff @(posedge clk or posedge areset) begin
  if (areset) begin
    current_state <= OFF;
    out <= 1'b0;
  end else begin
    current_state <= next_state;
    case (next_state)
      OFF: out <= 1'b0;
      ON:  out <= 1'b1;
    endcase
  end
end

endmodule