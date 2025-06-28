module MooreStateMachine (
  input clk,
  input in,
  input reset,
  output reg out
);

  typedef enum logic [1:0] {A, B, C, D} state_t;
  reg state_t current_state, next_state;
  
  always @(posedge clk or posedge reset) begin
    if(reset) begin
      current_state <= A;
    end
    else begin
      current_state <= next_state;
    end
  end
  
  always @(*) begin
    case(current_state)
      A: begin
        if(in) next_state = B;
        else next_state = A;
        out = 0;
      end
      B: begin
        if(in) next_state = C;
        else next_state = B;
        out = 0;
      end
      C: begin
        if(in) next_state = D;
        else next_state = A;
        out = 0;
      end
      D: begin
        if(in) next_state = B;
        else next_state = C;
        out = 1;
      end
      default: begin
        next_state = A;
        out = 0;
      end
    endcase
  end

endmodule