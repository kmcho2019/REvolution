module TopModule (
  input clk,
  input resetn,
  input x,
  input y,
  output reg f,
  output reg g
);

reg [1:0] state;
reg [1:0] x_history;
reg [1:0] y_count;

parameter A = 2'b00;  // Beginning state
parameter B = 2'b01;  // State after f = 1 for 1 clock cycle
parameter C = 2'b10;  // State after x has values 1, 0, 1
parameter D = 2'b11;  // State after monitoring y

always @ (posedge clk or negedge resetn) begin
  if (~resetn) begin
    state <= A;
    x_history <= 2'b00;
    y_count <= 2'b00;
    f <= 0;
    g <= 0;
  end
  else begin
    case(state)
      A: begin
        f <= 1;
        state <= B;
      end
      B: begin
        f <= 0;
        if (x == 1 && x_history == 2'b010) begin
          state <= C;
        end
        x_history <= {x_history[0], x};
      end
      C: begin
        g <= 0;
        if (x == 1 && x_history == 2'b010) begin
          g <= 1;
          state <= D;
        end
        else if (x != 1) begin
          x_history <= {x_history[0], x};
        end
      end
      D: begin
        g <= (y == 1) ? 1 : 0;
        if (y == 1 || y_count == 2'b11) begin
          y_count <= 2'b00;
        end
        else begin
          y_count <= y_count + 1;
        end
      end
    endcase
  end
end

endmodule