module TopModule (
  input clk,
  input reset,
  input [3:1] s,
  output reg fr3,
  output reg fr2,
  output reg fr1,
  output reg dfr
);

  reg [2:0] state;
  reg [2:0] prev_state;
  
  always @ (posedge clk) begin
    if (reset) begin
      state <= 3'b000;   // Reset state machine to state 0
      prev_state <= 3'b000;
      fr3 <= 1'b1;       // All flow rates asserted
      fr2 <= 1'b1;
      fr1 <= 1'b1;
      dfr <= 1'b1;
    end else begin
      prev_state <= state;
      case (state)
        3'b000: begin // No sensors asserted
          if (s[1]) state <= 3'b001; // Transition to s[1] state
          else begin
            fr3 <= 1'b1;  // All flow rates asserted
            fr2 <= 1'b1;
            fr1 <= 1'b1;
            dfr <= 1'b1;
          end
        end
        3'b001: begin  // s[1] asserted
          if (s[2] && !s[1]) begin // Transition to between s[2] and s[1]
            state <= 3'b011;
            fr1 <= 1'b1;  // Set nominal flow rate fr1
          end
          else if (!s[1]) begin  // Transition back to no sensors asserted
            state <= 3'b000;
            fr2 <= 1'b0;
            fr1 <= 1'b0;  // Close supplemental flow valve
            dfr <= 1'b0;  // Open supplemental flow valve
          end
        end
        3'b011: begin  // s[1] and s[2] asserted
          if (s[3] && !s[2]) begin // Transition to between s[3] and s[2]
            state <= 3'b100;
          end
          else if (!s[2]) begin  // Transition back to s[1] asserted
            state <= 3'b001;
          end
        end
        3'b100: begin  // s[3] asserted
          if (!s[3]) begin  // Transition back to s[1] and s[2] asserted
            state <= 3'b011;
            fr3 <= 1'b0;  // Close main flow valve
            fr2 <= 1'b0;
            fr1 <= 1'b0;  // Close supplemental flow valve
          end
        end
        default: state <= 3'b000;
      endcase
    end
  end
  
endmodule