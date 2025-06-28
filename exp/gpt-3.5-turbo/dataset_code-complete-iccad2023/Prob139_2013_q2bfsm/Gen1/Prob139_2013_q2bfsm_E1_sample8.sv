module TopModule (
  input clk,
  input resetn,
  input x,
  input y,
  output reg f,
  output reg g
);

  reg [1:0] state;
  reg [2:0] x_counter;
  reg [1:0] y_counter;

  always @ (posedge clk or negedge resetn) begin
    if (~resetn) begin
      state <= 2'b00; // State A
      f <= 0;
      g <= 0;
      x_counter <= 0;
      y_counter <= 0;
    end
    else begin
      case (state)
        2'b00: begin // State A
          f <= 1;
          if (x) begin
            x_counter <= x_counter + 1;
            if (x_counter == 3) begin
              state <= 2'b01; // Transition to State B
            end
          end
          else begin
            x_counter <= 0;
          end
        end
        2'b01: begin // State B
          f <= 0;
          if (x_counter == 3 && x) begin
            state <= 2'b10; // Transition to State C
          end
          else if (x) begin
            x_counter <= x_counter + 1;
          end
          else begin
            x_counter <= 0;
          end
        end
        2'b10: begin // State C
          if (g == 1) begin
            if (y == 1) begin
              g <= 1;
              y_counter <= 0;
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
          end
        end
        default: state <= 2'b00;
      endcase
    end
  end
endmodule