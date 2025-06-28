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
    if (~resetn) begin
      state <= 2'b00; // State A
      f <= 0;
      g <= 0;
    end
    else begin
      state <= next_state;
    end
  end
  
  always @(*) begin
    case (state)
      2'b00: begin // State A
        next_state = x ? 2'b01 : 2'b00;
        f = 1;
        g = 0;
      end
      2'b01: begin // Monitoring x
        next_state = (x && (state == 2'b01 || state == 2'b10)) ? 2'b10 : 2'b01;
        f = 0;
        g = 0; // Reset g
      end
      2'b10: begin // Monitoring x and y
        next_state = (y && (state == 2'b10 || state == 2'b11)) ? 2'b11 : 2'b01;
        f = 0;
        g = 1;
      end
      2'b11: begin // Permanent g
        f = 0;
        g = 1;
      end
    endcase
  end
endmodule