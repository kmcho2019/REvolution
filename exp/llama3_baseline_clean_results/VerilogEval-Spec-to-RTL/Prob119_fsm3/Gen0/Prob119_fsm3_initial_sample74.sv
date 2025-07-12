module TopModule(
  input        clk,
  input        areset,
  input        in,
  output logic out
);

// Define states as an enumeration
typedef enum logic [1:0] {
  A,
  B,
  C,
  D
} state_t;

// Current state
state_t current_state;
state_t next_state;

// Combinatorial logic to determine next state and output
always_comb begin
  case (current_state)
    A: begin
      if (~in) begin
        next_state = A;
      end else begin
        next_state = B;
      end
      out = 0;
    end
    B: begin
      if (~in) begin
        next_state = C;
      end else begin
        next_state = B;
      end
      out = 0;
    end
    C: begin
      if (~in) begin
        next_state = A;
      end else begin
        next_state = D;
      end
      out = 0;
    end
    D: begin
      if (~in) begin
        next_state = C;
      end else begin
        next_state = B;
      end
      out = 1;
    end
    default: begin
      next_state = A;
      out = 0;
    end
  endcase
end

// Sequential logic to update current state
always_ff @(posedge clk or posedge areset) begin
  if (areset) begin
    current_state <= A;
  end else begin
    current_state <= next_state;
  end
end

endmodule