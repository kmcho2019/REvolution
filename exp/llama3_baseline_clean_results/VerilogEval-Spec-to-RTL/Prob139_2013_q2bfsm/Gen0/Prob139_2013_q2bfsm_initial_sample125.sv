module TopModule(clk, resetn, x, y, f, g);
  input clk;
  input resetn;
  input x;
  input y;
  output reg f;
  output reg g;

  reg [1:0] state; // 0: A, 1: B, 2: C, 3: D
  reg [1:0] count; // counter for states C and D
  reg [2:0] x_seq; // sequence of x input

  always @(posedge clk) begin
    if (!resetn) begin
      state <= 0; // State A
      f <= 0;
      g <= 0;
      count <= 0;
      x_seq <= 0;
    end else begin
      case (state)
        0: begin // State A
          if (resetn) begin
            state <= 1; // State B
          end
        end
        1: begin // State B
          f <= 1;
          state <= 2; // State C
        end
        2: begin // State C
          x_seq <= {x_seq[1:0], x};
          if (x_seq == 5) begin // sequence 1, 0, 1
            state <= 3; // State D
            count <= 0;
            g <= 1;
          end
          f <= 0;
        end
        3: begin // State D
          count <= count + 1;
          if (y) begin
            state <= 3; // stay in State D
          end else if (count == 2) begin
            g <= 0;
            state <= 3; // stay in State D
          end
        end
      endcase
    end
  end
endmodule