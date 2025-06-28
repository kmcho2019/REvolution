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

// State and next state registers
reg [1:0] state, next_state;

// Synchronous state machine
always @(posedge clk or posedge reset) begin
  if (reset) begin
    state <= ABOVE_S3; // Reset to state equivalent to low water level
    fr3 <= 1;
    fr2 <= 1;
    fr1 <= 1;
    dfr <= 1;
  end else begin
    state <= next_state;
    fr3 <= 1;   // Default flow rates
    fr2 <= 1;
    fr1 <= 1;
    dfr <= 1;

    case (state)
      ABOVE_S3:
        if (!s[3]) begin
          next_state = BETWEEN_S3_S2;
          fr3 <= 0;
        end
      BETWEEN_S3_S2:
        if (!s[2]) begin
          next_state = BETWEEN_S2_S1;
          fr2 <= 0; // Open Nominal flow valve
        end else if (s[3]) begin
          next_state = ABOVE_S3;
          fr2 <= 1; // Close Nominal flow valve
        end
      BETWEEN_S2_S1:
        if (!s[1]) begin
          next_state = BELOW_S1;
          fr1 <= 0; // Open Supplemental flow valve
        end else if (s[2]) begin
          next_state = BETWEEN_S3_S2;
          fr1 <= 1; // Close Supplemental flow valve
        end
      BELOW_S1:
        if (s[1]) begin
          next_state = BETWEEN_S2_S1;
          fr3 <= 0; // Close Nominal flow valve
          fr2 <= 0;
          dfr <= 0; // Open Supplemental flow valve
        end
    endcase
  end
end

endmodule