module TopModule (
  input clk,
  input reset,
  input [3:1] s,
  output reg fr3,
  output reg fr2,
  output reg fr1,
  output reg dfr
);

  // Initialize flow rates and valves
  always @(posedge clk, posedge reset) begin
    if (reset) begin
      fr3 <= 1'b1;
      fr2 <= 1'b1;
      fr1 <= 1'b1;
      dfr <= 1'b1;
    end else begin
      // Reset all flow rates to high levels
      fr3 <= 1'b1;
      fr2 <= 1'b1;
      fr1 <= 1'b1;
      dfr <= 1'b1;
      
      // Determine the flow rates based on sensor inputs
      case (s)
        3'b111: begin // Water level above s[3]
          fr3 <= 1'b0;  // Close main flow valve
        end
        3'b110: begin // Water level between s[3] and s[2]
          fr1 <= 1'b1;  // Set nominal flow rate fr1
        end
        3'b101: begin // Water level between s[2] and s[1]
          fr1 <= 1'b1;  // Set nominal flow rate fr1
          fr2 <= 1'b1;  // Set nominal flow rate fr2
        end
        3'b100: begin // Water level below s[1]
          fr1 <= 1'b1;  // Set nominal flow rate fr1
          fr2 <= 1'b1;  // Set nominal flow rate fr2
          fr3 <= 1'b1;  // Set nominal flow rate fr3
          dfr <= 1'b0;  // Open supplemental flow valve
        end
        default: begin
          fr3 <= 1'b1;
          fr2 <= 1'b1;
          fr1 <= 1'b1;
          dfr <= 1'b1;
        end
      endcase
    end
  end

endmodule