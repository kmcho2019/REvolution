module TopModule (
  input clk,
  input resetn,
  input x,
  input y,
  output reg f,
  output reg g
);

  reg [1:0] state, next_state;

  always @(posedge clk or negedge resetn) begin
    if (~resetn)
      state <= 2'b00;
    else
      state <= next_state;
  end

  always @(*) begin
    case(state)
      2'b00: begin
        next_state = x ? 2'b01 : 2'b00;
        f = ~resetn;
        g = 0;
      end
      2'b01: begin
        next_state = (x == 1) ? 2'b10 : 2'b01;
        f = 0;
        g = 0;
      end
      2'b10: begin
        next_state = (y == 1) ? 2'b11 : ((y == 0) && (state == 2'b11)) ? 2'b00 : 2'b10;
        f = 0;
        g = (y == 1) ? 1 : 0;
      end
      2'b11: begin
        next_state = (y == 1) ? 2'b11 : 2'b00;
        f = 0;
        g = (y == 1) ? 1 : 0;
      end
    endcase
  end
endmodule