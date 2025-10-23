module TopModule(
  input clk,
  input reset,
  input in,
  output out
);

typedef enum {A, B} state_t;
state_t current_state, next_state;

always_comb begin
  case(current_state)
    A: begin
      if (!in) begin
        next_state = B;
      end else begin
        next_state = A;
      end
    end
    B: begin
      if (!in) begin
        next_state = A;
      end else begin
        next_state = B;
      end
    end
    default: next_state = B;
  endcase
end

always_ff @(posedge clk) begin
  if (reset) begin
    current_state <= B;
  end else begin
    current_state <= next_state;
  end
end

always_comb begin
  case(current_state)
    A: out = 0;
    B: out = 1;
    default: out = 1;
  endcase
end

endmodule