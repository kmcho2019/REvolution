module TopModule (
  input        clk,
  input        areset,
  input        j,
  input        k,
  output       out
);

// Define states
typedef enum logic [0:0] {OFF, ON} state_t;

// Current and next state
state_t current_state, next_state;

// Assign output based on state
always_comb begin
  case (current_state)
    OFF: out = 1'b0;
    ON:  out = 1'b1;
  endcase
end

// State transition logic
always_ff @(posedge clk or posedge areset) begin
  if (areset) begin
    current_state <= OFF;
  end else begin
    case (current_state)
      OFF: begin
        if (j) begin
          current_state <= ON;
        end else begin
          current_state <= OFF;
        end
      end
      ON: begin
        if (k) begin
          current_state <= OFF;
        end else begin
          current_state <= ON;
        end
      end
    endcase
  end
end

endmodule