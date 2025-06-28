module TopModule (
  input clk,
  input a,
  input b,
  output q,
  output state
);
  
  reg state, next_state;
  reg q;
  
  always @(posedge clk) begin
    case(state)
      0: begin
        if (a == 0 && b == 0) begin
          next_state = 0;
          q = 0;
        end
        else if (a == 0 && b == 1) begin
          next_state = 0;
          q = 1;
        end
        else if (a == 1 && b == 0) begin
          next_state = 0;
          q = 1;
        end
        else if (a == 1 && b == 1) begin
          next_state = 1;
          q = 1;
        end
      end
      1: begin
        if (a == 0 && b == 0) begin
          next_state = 1;
          q = 1;
        end
        else if (a == 0 && b == 1) begin
          next_state = 0;
          q = 1;
        end
        else if (a == 1 && b == 0) begin
          next_state = 0;
          q = 1;
        end
        else if (a == 1 && b == 1) begin
          next_state = 1;
          q = 0;
        end
      end
    endcase
    state <= next_state;
  end

endmodule