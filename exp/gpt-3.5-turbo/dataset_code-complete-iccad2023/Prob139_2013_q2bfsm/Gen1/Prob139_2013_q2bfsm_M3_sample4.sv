module TopModule (
  input clk,
  input resetn,
  input x,
  input y,
  output reg f,
  output reg g
);

  // FSM states
  parameter A = 2'b00, B = 2'b01, C = 2'b10;
  reg [1:0] state;

  always @(posedge clk or negedge resetn) begin
    if (~resetn) begin
      state <= A;
      f <= 0;
      g <= 0;
    end
    else begin
      case (state)
        A: begin
          f <= 1;
          if (x == 1 && y == 0) begin
            state <= B;
          end
        end
        B: begin
          f <= 0;
          if (x == 1 && y == 0) begin
            state <= C;
          end
        end
        C: begin
          if (x == 1 && y == 0) begin
            g <= 1;
          end
          else if (y == 1) begin
            g <= 1;
          end
          else begin
            g <= 0;
          end
        end
        default: state <= A;
      endcase
    end
  end

endmodule