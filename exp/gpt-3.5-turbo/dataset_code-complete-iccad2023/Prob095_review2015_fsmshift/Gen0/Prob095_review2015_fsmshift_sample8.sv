module TopModule (
  input clk,
  input reset,
  output reg shift_ena
);

reg [2:0] counter;
reg detected_pattern;
reg [1:0] state;

always @(posedge clk or posedge reset) begin
  if (reset) begin
    counter <= 0;
    detected_pattern <= 0;
    state <= 0;
    shift_ena <= 1;
  end
  else begin
    case(state)
      2'b00: begin // Detect proper pattern
        if (data_pattern_detected) begin
          state <= 2'b01; // Enable shift_ena
          counter <= 0;
        end
      end
      2'b01: begin // Enable shift_ena
        if (counter < 3) begin
          counter <= counter + 1;
          shift_ena <= 1;
        end
        else begin
          counter <= 0;
          state <= 2'b00; // Go back to detect proper pattern
          shift_ena <= 0;
        end
      end
    endcase
  end
end

endmodule