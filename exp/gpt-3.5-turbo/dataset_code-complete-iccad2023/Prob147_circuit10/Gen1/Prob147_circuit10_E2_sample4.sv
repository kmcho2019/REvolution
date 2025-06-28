module TopModule (
  input clk,
  input a,
  input b,
  output reg q,
  output reg state
);

reg [1:0] current_state, next_state;

always @(posedge clk) begin
  current_state <= next_state;
end

always @(*) begin
  case (current_state)
    2'd0: begin
      if (a == 0 && b == 0)
        next_state = 2'd0;
      else if (a == 0 && b == 1)
        next_state = 2'd1;
      else if (a == 1 && b == 0)
        next_state = 2'd2;
    end
    2'd1: begin
      next_state = 2'd0;
    end
    2'd2: begin
      if (a == 1 && b == 1)
        next_state = 2'd3;
    end
    2'd3: begin
      next_state = 2'd1;
    end
    default: next_state = 2'd0;
  endcase
end

always @(posedge clk) begin
  case (current_state)
    2'd0: begin
      q = 1'b0;
      state = 1'b0;
    end
    2'd1: begin
      q = 1'b1;
      state = 1'b1;
    end
    2'd2: begin
      q = 1'b1;
      state = 1'b0;
    end
    2'd3: begin
      q = 1'b0;
      state = 1'b1;
    end
    default: begin
      q = 1'b0;
      state = 1'b0;
    end
  endcase
end

endmodule