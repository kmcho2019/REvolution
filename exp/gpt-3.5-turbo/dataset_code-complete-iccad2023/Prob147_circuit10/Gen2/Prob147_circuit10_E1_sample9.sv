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

always @* begin
  case (current_state)
    2'b00: begin
      next_state = (a & ~b) ? 2'b01 : 2'b00;
      q = 1'b0;
      state = current_state;
    end
    2'b01: begin
      next_state = (a & b) ? 2'b10 : (a & ~b) ? 2'b00 : 2'b01;
      q = b;
      state = current_state;
    end
    2'b10: begin
      next_state = (~a & b) ? 2'b11 : 2'b00;
      q = a;
      state = current_state;
    end
    2'b11: begin
      next_state = (~a & ~b) ? 2'b00 : 2'b10;
      q = ~a;
      state = current_state;
    end
    default: begin
      next_state = 2'b00;
      q = 1'b0;
      state = 2'b00;
    end
  endcase
end

endmodule