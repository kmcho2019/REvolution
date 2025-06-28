module TopModule (
  input clk,
  input reset,
  input [3:1] s,
  output reg fr3,
  output reg fr2,
  output reg fr1,
  output reg dfr
);

  reg [1:0] state;
  reg [1:0] prev_state;
  
  always @ (posedge clk) begin
    if (reset) begin
      state <= 2'b00;   // Reset state machine to state 0
      prev_state <= 2'b00;
      fr3 <= 1'b1;       // All flow rates asserted
      fr2 <= 1'b1;
      fr1 <= 1'b1;
      dfr <= 1'b1;
    end else begin
      prev_state <= state;
      case ({s[3], s[2], s[1]})
        3'b100: begin // Water level above s[3]
          state <= 2'b11;  // All sensors asserted
          fr3 <= 1'b0;     // Close main flow valve
        end
        3'b011: begin  // Water level between s[3] and s[2]
          state <= 2'b10;  // s[1] and s[2] asserted
          if (prev_state == 2'b01) begin  // Water level increase
            fr1 <= 1'b1;  // Open nominal flow rate fr1
          end
        end
        3'b010: begin  // Water level between s[2] and s[1]
          state <= 2'b01;  // Only s[1] asserted
          if (prev_state == 2'b10) begin  // Water level increase
            fr2 <= 1'b1;  // Open nominal flow rate fr2
          end
          fr1 <= 1'b1;  // Open nominal flow rate fr1
        end
        default: begin  // Water level below s[1]
          state <= 2'b00;  // No sensors asserted
          if (prev_state == 2'b01) begin  // Water level increase
            fr3 <= 1'b1;  // Open nominal flow rate fr3
            dfr <= 1'b1;  // Open supplemental flow valve
          end
          else begin
            fr3 <= 1'b0;  // Close main flow valve
            fr2 <= 1'b0;
            fr1 <= 1'b0;  // Close supplemental flow valve
            dfr <= 1'b0;
          end 
        end
      endcase
    end
  end
  
endmodule