module TopModule (
  input clk,
  input reset,
  input [3:1] s,
  output reg fr3,
  output reg fr2,
  output reg fr1,
  output reg dfr
);

  // State encoding
  localparam BELOW    = 2'd0;
  localparam MID_LOW  = 2'd1;
  localparam MID_HIGH = 2'd2;
  localparam ABOVE    = 2'd3;

  reg [1:0] state, next_state;

  // Function to determine water level state from sensors
  // Sensors are active high: s[3] highest, s[1] lowest
  // According to specs:
  // ABOVE: s[3]=1,s[2]=1,s[1]=1 => 3'b111
  // MID_HIGH: s[3]=0,s[2]=1,s[1]=1 => 3'b011
  // MID_LOW: s[3]=0,s[2]=0,s[1]=1 => 3'b001
  // BELOW: s[3]=0,s[2]=0,s[1]=0 => 3'b000
  function [1:0] get_level(input [3:1] sensors);
    begin
      case (sensors)
        3'b111: get_level = ABOVE;
        3'b011: get_level = MID_HIGH;
        3'b001: get_level = MID_LOW;
        3'b000: get_level = BELOW;
        default: get_level = BELOW; // For any other pattern treat as BELOW
      endcase
    end
  endfunction

  reg [1:0] prev_state;

  // Update FSM state synchronously
  always @(posedge clk) begin
    if (reset) begin
      state <= BELOW;     // Reset to BELOW state (lowest level)
      prev_state <= BELOW; // Also init prev_state to BELOW for correct dfr on first cycle
    end else begin
      prev_state <= state;
      state <= get_level(s);
    end
  end

  // Determine if water level rose: current state > previous state
  wire level_rose = (state > prev_state);

  // Output logic based on state and level rise
  always @(*) begin
    case(state)
      ABOVE: begin
        // No nominal flow, no supplemental flow
        fr1 = 0;
        fr2 = 0;
        fr3 = 0;
        dfr = 0;
      end
      MID_HIGH: begin
        // fr1 only nominal
        fr1 = 1;
        fr2 = 0;
        fr3 = 0;
        dfr = level_rose ? 1 : 0;
      end
      MID_LOW: begin
        // fr1, fr2 nominal
        fr1 = 1;
        fr2 = 1;
        fr3 = 0;
        dfr = level_rose ? 1 : 0;
      end
      BELOW: begin
        // fr1, fr2, fr3 nominal
        fr1 = 1;
        fr2 = 1;
        fr3 = 1;
        dfr = level_rose ? 1 : 0;
      end
      default: begin
        // Default safe outputs
        fr1 = 1;
        fr2 = 1;
        fr3 = 1;
        dfr = 0;
      end
    endcase
  end

endmodule