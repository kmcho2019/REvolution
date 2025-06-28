module TopModule (
  input clk,
  input reset,
  input [3:1] s,
  output reg fr3,
  output reg fr2,
  output reg fr1,
  output reg dfr
);

reg [1:0] prev_sensor_diff;

always @(*) begin
  if (reset) begin
    fr3 <= 1'b1;  // All flow rates asserted
    fr2 <= 1'b1;
    fr1 <= 1'b1;
    dfr <= 1'b1;
    prev_sensor_diff <= 2'b00; // Initialize previous sensor difference
  end else begin
    if (s[1] && s[2] && s[3]) begin
      fr3 <= 1'b0;  // Above s[3], close main flow valve
      fr2 <= 1'b1;
      fr1 <= 1'b1;
      dfr <= 1'b0;
    end else if (s[2] && s[1]) begin
      if (prev_sensor_diff == 2'b01) begin  // Sensor change from s[2] to s[1]
        fr1 <= 1'b1;  // Open supplemental flow valve
      end
      fr3 <= 1'b0;  // Close main flow valve
      fr2 <= 1'b1;
      dfr <= 1'b0;
    end else if (s[1]) begin
      if (prev_sensor_diff == 2'b10) begin  // Sensor change from s[1] to no sensors
        fr2 <= 1'b0;  // Close supplemental flow valve
        fr1 <= 1'b0;
        dfr <= 1'b1;  // Open nominal flow valve
      end
      fr3 <= 1'b0;
      fr2 <= 1'b1;
    end else begin // Below s[1], open all valves
      fr3 <= 1'b0;
      fr2 <= 1'b0;
      fr1 <= 1'b0;
      dfr <= 1'b1;
    end
    prev_sensor_diff <= {s[2], s[1]}; // Track sensor changes
  end
end

endmodule