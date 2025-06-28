module TopModule (
  input clk,
  input reset,
  input w,
  output reg z
);

// Enumerated type for states
typedef enum logic [2:0] {
  A, B, C, D, E, F
} StateType;

// State register and next state logic
reg [2:0] state, next_state;

always @ (posedge clk or posedge reset) begin
  if (reset) begin
    state <= A;
  end else begin
    state <= next_state;
  end
end

always @ (*) begin
  case(state)
    A: begin
      case(w)
        1: next_state = A;
        0: next_state = B;
      endcase
    end

    B: begin
      case(w)
        1: next_state = D;
        0: next_state = C;
      endcase
    end

    C: begin
      case(w)
        1: next_state = D;
        0: next_state = E;
      endcase
    end

    D: begin
      case(w)
        1: next_state = A;
        0: next_state = F;
      endcase
    end

    E: begin
      case(w)
        1: next_state = D;
        0: next_state = E;
      endcase
    end

    F: begin
      case(w)
        1: next_state = D;
        0: next_state = C;
      endcase
    end
  endcase
end

// Output logic
always @ (*) begin
  case(state)
    E: z = 1'b1;
    default: z = 1'b0;
  endcase
end

endmodule