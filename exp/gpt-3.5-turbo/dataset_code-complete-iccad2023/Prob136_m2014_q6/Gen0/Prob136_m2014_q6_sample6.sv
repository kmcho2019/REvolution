module TopModule (
  input clk,
  input reset,
  input w,
  output reg z
);

  typedef enum logic [2:0] {
    A, B, C, D, E, F
  } state_t;

  reg [2:0] state, next_state;

  always @ (posedge clk or posedge reset) begin
    if (reset) begin
      state <= A;
    end
    else begin
      state <= next_state;
    end
  end

  always @* begin
    case(state)
      A: begin
        if (w == 1)
          next_state = A;
        else
          next_state = B;
      end
      B: begin
        if (w == 1)
          next_state = D;
        else
          next_state = C;
      end
      C: begin
        if (w == 1)
          next_state = D;
        else
          next_state = E;
      end
      D: begin
        if (w == 1)
          next_state = A;
        else
          next_state = F;
      end
      E: begin
        if (w == 1)
          next_state = D;
        else
          next_state = E;
      end
      F: begin
        if (w == 1)
          next_state = D;
        else
          next_state = C;
      end
      default: next_state = A;
    endcase
  end

  always @* begin
    if(state == E || state == F)
      z = 1;
    else
      z = 0;
  end

endmodule