module TopModule (
  input clk,
  input in,
  input reset,
  output reg out
);
  
  reg [1:0] state_reg, next_state;
  parameter B = 2'b00, A = 2'b01;
  
  always @ (posedge clk) begin
    if (reset) begin
      state_reg <= B;
      out <= 1;
    end
    else begin
      state_reg <= next_state;
      case (state_reg)
        B: begin
          if (in)
            next_state = B;
          else
            next_state = A;
        end
        A: begin
          if (in)
            next_state = A;
          else
            next_state = B;
        end
      endcase
    end
  end

endmodule