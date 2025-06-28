module TopModule (
  input clk,
  input resetn,
  input x,
  input y,
  output reg f,
  output reg g
);

  reg [3:0] state;
  reg [2:0] x_history;
  reg [1:0] y_counter;

  always @ (posedge clk or negedge resetn) begin
    if (~resetn) begin
      state <= 4'b0000; // State A
      f <= 0;
      g <= 0;
    end
    else begin
      case (state)
        4'b0000: begin // State A
          f <= 1;
          state <= 4'b0001; // Transition to State B
        end
        4'b0001: begin // State B
          if (x_history == 3'b101) begin
            state <= 4'b0010; // Transition to State C
          end
          x_history <= {x_history[1:0], x};
        end
        4'b0010: begin // State C
          if (g == 1) begin
            if (y == 1) begin
              g <= 1;
            end
            else begin
              if (y_counter < 2) begin
                y_counter <= y_counter + 1;
              end
              else begin
                g <= 0;
              end
            end
          end
          else begin
            if (y == 1) begin
              g <= 1;
            end
            else begin
              g <= 0;
            end
          end
          state <= 4'b0010; // Stay in State C
        end
        default: state <= 4'b0000; // Default to State A
      endcase
    end
  end
endmodule