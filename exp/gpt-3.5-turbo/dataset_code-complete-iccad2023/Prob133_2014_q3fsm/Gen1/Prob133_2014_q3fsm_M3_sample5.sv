module TopModule (
  input clk,
  input reset,
  input s,
  input w,
  output reg z
);

  reg [1:0] state;
  reg [1:0] w_counter;

  always @(posedge clk or posedge reset) begin
    if (reset) begin
      state <= 2'b00;
      w_counter <= 2'b00;
      z <= 0;
    end else begin
      case(state)
        2'b00: begin // State A
          if (s == 1)
            state <= 2'b01; // Move to State B
        end
        2'b01: begin // State B
          if (w) begin
            w_counter <= w_counter + 1;
          end
          if (w_counter == 2) begin
            z <= 1;
          end else begin
            z <= 0;
          end
          state <= 2'b00; // Move back to State A
          w_counter <= 2'b00; // Reset counter for next set of cycles
        end
      endcase
    end
  end
endmodule