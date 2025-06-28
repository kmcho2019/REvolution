module TopModule (
  input clk,
  input reset,
  input [3:1] s,
  output reg fr3,
  output reg fr2,
  output reg fr1,
  output reg dfr
);

// State definitions
parameter IDLE = 2'b00; // No sensors asserted
parameter ABOVE_S3 = 2'b01; // Sensors s[1], s[2], s[3] asserted
parameter BTW_S3_S2 = 2'b10; // Sensors s[1], s[2] asserted
parameter BTW_S2_S1 = 2'b11; // Sensor s[1] asserted

// State and next state register
reg [1:0] state, next_state;

// Output control logic
always @(*) begin
  fr3 = (state == BTW_S3_S2 || state == IDLE) ? 1'b1 : 1'b0;
  fr2 = (state == BTW_S2_S1 || state == BTW_S3_S2 || state == IDLE) ? 1'b1 : 1'b0;
  fr1 = (state == BTW_S2_S1 || state == IDLE) ? 1'b1 : 1'b0;
  dfr = (state == BTW_S3_S2) ? 1'b1 : 1'b0;
end

// State transition and reset logic
always @(posedge clk) begin
  if (reset) begin
    state <= IDLE;
  end else begin
    case(state)
      IDLE: begin
        if (s[1] && s[2] && s[3])
          next_state = ABOVE_S3;
        else if (s[1] && s[2])
          next_state = BTW_S3_S2;
        else if (s[1])
          next_state = BTW_S2_S1;
      end
      ABOVE_S3: begin
        if (!(s[1] && s[2] && s[3]))
          next_state = BTW_S3_S2;
      end
      BTW_S3_S2: begin
        if (!(s[1] && s[2]))
          next_state = BTW_S2_S1;
        else if (!(s[1] && s[2] && s[3]))
          next_state = IDLE;
      end
      BTW_S2_S1: begin
        if (!(s[1]))
          next_state = IDLE;
      end
      default: next_state = IDLE;
    endcase
  end
end

endmodule