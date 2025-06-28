module TopModule (
  input clk,
  input reset,
  input [3:1] s,
  output reg fr3,
  output reg fr2,
  output reg fr1,
  output reg dfr
);

// Enumerated states for the state machine
parameter ABOVE_S3 = 2'b00;
parameter BETWEEN_S3_S2 = 2'b01;
parameter BETWEEN_S2_S1 = 2'b10;
parameter BELOW_S1 = 2'b11;

// State registers
reg [1:0] state, next_state;
reg prev_sensor_s1;

always @(posedge clk) begin
  if (reset) begin
    state <= BELOW_S1; // Initialize to 'below s[1]' state
    prev_sensor_s1 <= 0;
  end else begin
    state <= next_state;
    prev_sensor_s1 <= s[1];
  end
end

always @(*) begin
  case (state)
    ABOVE_S3:
      if (s[3]) begin
        fr3 = 0;
        fr2 = 0;
        fr1 = 0;
        dfr = 0;
        next_state = ABOVE_S3;
      end else if (s[2]) begin
        fr3 = 0;
        fr2 = 1;
        fr1 = 0;
        dfr = prev_sensor_s1 ? 1 : 0;
        next_state = BETWEEN_S3_S2;
      end else begin
        fr3 = 0;
        fr2 = 1;
        fr1 = 1;
        dfr = 1;
        next_state = BETWEEN_S2_S1;
      end
    BETWEEN_S3_S2:
      if (!s[2]) begin
        fr3 = 0;
        fr2 = 1;
        fr1 = 0;
        dfr = 0;
        next_state = ABOVE_S3;
      end
    BETWEEN_S2_S1:
      if (!s[1]) begin
        fr3 = 1;
        fr2 = 1;
        fr1 = 0;
        dfr = 0;
        next_state = ABOVE_S3;
      end
    BELOW_S1:
      if (s[1]) begin
        fr3 = 1;
        fr2 = 1;
        fr1 = 0;
        dfr = 0;
        next_state = BETWEEN_S2_S1;
      end
  endcase
end

endmodule