module TopModule (
  input clk,
  input a,
  input b,
  output reg [1:0] q,
  output reg [1:0] state
);

reg [1:0] next_state;

always @(posedge clk) begin
  case({state, a, b})
    6'b00_0_0: begin
      next_state = 2'b00;
      q = 2'b00;
    end
    6'b00_0_1: begin
      next_state = 2'b01;
      q = 2'b01;
    end
    6'b00_1_0: begin
      next_state = 2'b10;
      q = 2'b01;
    end
    6'b00_1_1: begin
      next_state = 2'b11;
      q = 2'b00;
    end
    6'b01_0_0: begin
      next_state = 2'b00;
      q = 2'b00;
    end
    6'b01_0_1: begin
      next_state = 2'b01;
      q = 2'b01;
    end
    6'b01_1_0: begin
      next_state = 2'b10;
      q = 2'b01;
    end
    6'b01_1_1: begin
      next_state = 2'b11;
      q = 2'b01;
    end
    6'b10_0_0: begin
      next_state = 2'b00;
      q = 2'b00;
    end
    6'b10_0_1: begin
      next_state = 2'b01;
      q = 2'b01;
    end
    6'b10_1_0: begin
      next_state = 2'b10;
      q = 2'b01;
    end
    6'b10_1_1: begin
      next_state = 2'b11;
      q = 2'b01;
    end
    6'b11_0_0: begin
      next_state = 2'b00;
      q = 2'b00;
    end
    6'b11_0_1: begin
      next_state = 2'b01;
      q = 2'b01;
    end
    6'b11_1_0: begin
      next_state = 2'b10;
      q = 2'b01;
    end
    6'b11_1_1: begin
      next_state = 2'b11;
      q = 2'b01;
    end
  endcase
  state <= next_state;
end

endmodule