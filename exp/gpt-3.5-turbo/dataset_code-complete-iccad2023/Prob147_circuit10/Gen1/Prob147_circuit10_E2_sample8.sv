module TopModule (
  input clk,
  input a,
  input b,
  output reg q,
  output reg state
);

reg next_state;

always @(posedge clk) begin
  case(state)
    2'b00: begin
      if (a == 0 && b == 1) begin
        next_state = 1;
        q = 1;
      end else begin
        next_state = 0;
        q = 0;
      end
    end
    2'b01: begin
      if (a == 1 && b == 0) begin
        next_state = 0;
        q = 1;
      end else begin
        next_state = 1;
        q = 1;
      end
    end
    2'b10: begin
      if (a == 1 && b == 1) begin
        next_state = 1;
        q = 1;
      end else begin
        next_state = 0;
        q = 1;
      end
    end
    2'b11: begin
      if (a == 1 && b == 1) begin
        next_state = 1;
        q = 1;
      end else begin
        next_state = 0;
        q = 0;
      end
    end
  endcase
  state <= next_state;
end

endmodule