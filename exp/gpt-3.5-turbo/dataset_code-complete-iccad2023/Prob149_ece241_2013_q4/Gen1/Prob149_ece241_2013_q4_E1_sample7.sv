module TopModule (
  input clk,
  input reset,
  input [3:1] s,
  output reg fr3,
  output reg fr2,
  output reg fr1,
  output reg dfr
);

  reg [1:0] current_level;
  reg [1:0] prev_level;

  // Initialize state machine to low water level state
  always @(*) begin
    case (s)
      3'b000: current_level = 2'b00; // Below s[1]
      3'b001: current_level = 2'b01; // Between s[2] and s[1]
      3'b010: current_level = 2'b10; // Between s[3] and s[2]
      default: current_level = 2'b11; // Above s[3]
    endcase
  end

  always @(posedge clk or posedge reset) begin
    if (reset) begin
        fr3 <= 1'b1; // Reset all output flow rates
        fr2 <= 1'b1;
        fr1 <= 1'b1;
        dfr <= 1'b1;
        prev_level <= 2'b00; // Reset previous water level
    end else begin
        if (current_level > prev_level) begin
          case (current_level)
            2'b00: begin // Below s[1]
              fr3 <= 1'b0; // Close main flow valve
              fr2 <= 1'b0;
              fr1 <= 1'b0;
              dfr <= 1'b0; // Open supplemental flow valve
            end
            2'b01: begin // Between s[2] and s[1]
              fr3 <= 1'b0;
              fr2 <= 1'b0;
              fr1 <= 1'b1; // Set nominal flow rate fr1
              dfr <= 1'b0;
            end
            2'b10: begin // Between s[3] and s[2]
              fr3 <= 1'b0;
              fr2 <= 1'b1; // Set nominal flow rate fr1
              fr1 <= 1'b1;
              dfr <= 1'b1;
            end
            default: begin // Above s[3]
              fr3 <= 1'b1;
              fr2 <= 1'b1;
              fr1 <= 1'b1;
              dfr <= 1'b1;
            end
          endcase
        end
        prev_level <= current_level; // Update previous water level
    end
  end

endmodule