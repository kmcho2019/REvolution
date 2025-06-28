module TopModule (
  input clk,
  input reset,
  input s,
  input w,
  output reg z
);

  reg [1:0] state;
  reg [1:0] w_counter;

  always @(posedge clk) begin
    if (reset) begin
      state <= 2'b00;
      w_counter <= 2'b00;
      z <= 0;
    end else begin
      case(state)
        2'b00: begin // State A
          if (s == 1)
            state <= 2'b01; // Move to State B
          else
            state <= 2'b00; // Stay in State A
        end
        2'b01: begin // State B
          if (w == 1) begin
            w_counter <= w_counter + 1;
          end
          if (w_counter == 2) begin
            z <= 1;
          end else begin
            z <= 0;
          end
          state <= 2'b00; // Move back to State A
        end
      endcase
    end
  end
endmodule