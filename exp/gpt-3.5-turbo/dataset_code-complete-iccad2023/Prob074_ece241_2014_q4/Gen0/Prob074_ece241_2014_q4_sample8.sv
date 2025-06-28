module TopModule (
  input clk,
  input x,
  output reg z
);

  reg [1:0] state, next_state;
  reg flipflop1, flipflop2, flipflop3;
  
  always @(posedge clk) begin
    case (state)
      2'b00: begin
        if (x) next_state = 2'b10;
        else next_state = 2'b01;
      end
      2'b01: next_state = 2'b10;
      2'b10: next_state = 2'b11;
      2'b11: next_state = 2'b00;
    endcase
  end
  
  always @(posedge clk) begin
    case (state)
      2'b00: begin
        flipflop1 <= x ^ flipflop1;
        flipflop2 <= x & ~flipflop2;
        flipflop3 <= x | ~flipflop3;
      end
      2'b01: begin
        flipflop1 <= x ^ flipflop1;
        flipflop2 <= x & ~flipflop2;
        flipflop3 <= x | ~flipflop3;
      end
      2'b10: begin
        flipflop1 <= x ^ flipflop1;
        flipflop2 <= x & ~flipflop2;
        flipflop3 <= x | ~flipflop3;
      end
      2'b11: begin
        flipflop1 <= x ^ flipflop1;
        flipflop2 <= x & ~flipflop2;
        flipflop3 <= x | ~flipflop3;
      end
    endcase
  end
  
  always @(posedge clk) begin
    state <= next_state;
  end
  
  assign z = ~(flipflop1 | flipflop2 | flipflop3);
  
endmodule