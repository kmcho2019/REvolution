module TopModule (
  input clk,
  input resetn,
  input x,
  input y,
  output reg f,
  output reg g
);

  reg [2:0] state;
  reg [2:0] x_history;
  reg [1:0] y_counter;

  always @ (posedge clk or negedge resetn) begin
    if (~resetn) begin
      state <= 3'b000; // State A
      f <= 0;
      g <= 0;
      x_history <= 3'b000;
      y_counter <= 0;
    end
    else begin
      case (state)
        3'b000: begin // State A
          f <= 1;
          state <= 3'b001; // Transition to State B
        end
        3'b001: begin // State B
          if (x_history == 3'b101) begin
            state <= 3'b010; // Transition to State C
          end
          x_history <= {x_history[1:0], x};
        end
        3'b010: begin // State C
          if (y == 1 && y_counter < 2) begin
            y_counter <= y_counter + 1;
          end
          else if (y == 1 && y_counter >= 2) begin
            g <= 1;
          end
          else if (y != 1 || (y == 1 && y_counter < 2)) begin
            g <= 0;
          end
        end
      endcase
    end
  end
endmodule