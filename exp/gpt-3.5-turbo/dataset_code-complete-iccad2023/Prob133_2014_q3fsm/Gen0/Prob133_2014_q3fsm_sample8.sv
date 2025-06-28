module TopModule (
  input clk,
  input reset,
  input s,
  input w,
  output reg z
);

// Define states
parameter A = 2'b00;
parameter B = 2'b01;

reg [1:0] state, next_state;
reg count, next_count;

always @(posedge clk or posedge reset) begin
  if (reset) begin
    state <= A;
    count <= 0;
    z <= 0;
  end
  else begin
    state <= next_state;
    count <= next_count;
    z <= (count == 2) ? 1'b1 : 1'b0;
  end
end

always @* begin
  next_state = state;
  next_count = count;

  case(state)
    A: begin
      if (s == 1)
        next_state = B;
      else
        next_state = A;
      next_count = 0;
    end
    B: begin
      if (w == 1)
        next_count = count + 1;
      else
        next_count = count;
      
      if (count == 2)
        next_state = A;
      else
        next_state = B;
    end
  endcase
end

endmodule