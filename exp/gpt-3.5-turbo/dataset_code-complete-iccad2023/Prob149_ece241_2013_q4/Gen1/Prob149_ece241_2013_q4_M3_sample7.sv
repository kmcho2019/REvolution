module TopModule (
  input clk,
  input reset,
  input [3:1] s,
  output reg fr3,
  output reg fr2,
  output reg fr1,
  output reg dfr
);

  always @ (posedge clk or posedge reset) begin
    if (reset) begin
      fr3 <= 1'b1;  // All flow rates asserted
      fr2 <= 1'b1;
      fr1 <= 1'b1;
      dfr <= 1'b1;
    end
    else begin
      case (s)
        3'b100: begin // Above s[3]
          fr3 <= 1'b0;  // Close main flow valve
          fr2 <= 1'b0;
          fr1 <= 1'b0;  // Close supplemental flow valve
          dfr <= 1'b0;
        end
        3'b010: begin // Between s[3] and s[2]
          fr3 <= 1'b1;  // Set nominal flow rate fr1
          fr2 <= 1'b1;
          fr1 <= 1'b0;  // Close supplemental flow valve
          dfr <= 1'b0;
        end
        3'b001: begin // Between s[2] and s[1]
          fr3 <= 1'b1;  // Set nominal flow rate fr1
          fr2 <= 1'b0;
          fr1 <= 1'b0;  // Close supplemental flow valve
          dfr <= 1'b0;
        end
        default: begin // Below s[1]
          fr3 <= 1'b1;  // All flow rates asserted
          fr2 <= 1'b1;
          fr1 <= 1'b1;
          dfr <= 1'b1;
        end
      endcase
    end
  end
  
endmodule