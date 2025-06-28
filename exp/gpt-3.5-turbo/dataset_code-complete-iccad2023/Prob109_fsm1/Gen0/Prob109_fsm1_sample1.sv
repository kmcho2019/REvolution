module TopModule (
  input clk,
  input in,
  input areset,
  output reg out
);

  reg state, next_state;

  parameter A = 1'b0;
  parameter B = 1'b1;

  always @(posedge clk or posedge areset) begin
    if (areset) begin
      state <= B;
    end else begin
      state <= next_state;
    end
  end
    
  always @* begin
    case (state)
      A: begin
        if (in)
          next_state = A;
        else
          next_state = B;
      end
      B: begin
        if (in)
          next_state = A;
        else
          next_state = B;
      end
    endcase
  end

  assign out = state;

endmodule