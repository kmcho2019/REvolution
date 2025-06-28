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

always @(a, b, current_state) begin
  case (current_state)
    2'b00: next_state = (a == 0 && b == 0) ? 2'b00 : (a == 0 && b == 1) ? 2'b01 : (a == 1 && b == 0) ? 2'b10 : 2'b00;
    2'b01: next_state = 2'b00;
    2'b10: next_state = (a == 1 && b == 1) ? 2'b11 : 2'b10;
    2'b11: next_state = 2'b01;
    default: next_state = 2'b00;
  endcase
end

always @* begin
  case (current_state)
    2'b00: begin
      q = 1;
      state = 0;
    end
    2'b01: begin
      q = 1;
      state = 0;
    end
    2'b10: begin
      q = 1;
      state = 1;
    end
    2'b11: begin
      q = 0;
      state = 1;
    end
    default: begin
      q = 1;
      state = 0;
    end
  endcase
end

endmodule