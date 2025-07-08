module TopModule (
  input clk,
  input reset,
  input [3:1] s,
  output reg fr3,
  output reg fr2,
  output reg fr1,
  output reg dfr
);

  // Define states for water level zones
  localparam BELOW_S1     = 2'd0; // None asserted
  localparam BETWEEN_S2_1 = 2'd1; // s1 asserted only
  localparam BETWEEN_S3_2 = 2'd2; // s1 and s2 asserted
  localparam ABOVE_S3     = 2'd3; // s1, s2, s3 asserted

  reg [1:0] curr_state, next_state;
  reg [1:0] prev_state;

  // Determine current water level state from sensor inputs
  always @(*) begin
    // Sensor pattern matching according to description
    // s[3], s[2], s[1]
    case ({s[3], s[2], s[1]})
      3'b111: next_state = ABOVE_S3;       // all asserted
      3'b011: next_state = BETWEEN_S3_2;   // s1 and s2 only
      3'b001: next_state = BETWEEN_S2_1;   // s1 only
      3'b000: next_state = BELOW_S1;       // none asserted
      default: 
        // Invalid sensor combination (e.g. s2 asserted but not s1)
        // Assign next_state to closest valid below (safe fallback)
        if (s[1]) begin
          if (s[2]) next_state = BETWEEN_S3_2;
          else next_state = BETWEEN_S2_1;
        end else begin
          next_state = BELOW_S1;
        end
    endcase
  end

  // State update and previous state register
  always @(posedge clk) begin
    if (reset) begin
      curr_state <= BELOW_S1;
      prev_state <= BELOW_S1;
    end else begin
      prev_state <= curr_state;
      curr_state <= next_state;
    end
  end

  // Outputs based on current state and previous state
  // dfr is asserted if water level rises (prev_state < curr_state)
  always @(*) begin
    // default outputs
    fr1 = 0;
    fr2 = 0;
    fr3 = 0;
    dfr = 0;

    case (curr_state)
      ABOVE_S3: begin
        // No valves open
        fr1 = 0; fr2 = 0; fr3 = 0; dfr = 0;
      end

      BETWEEN_S3_2: begin
        // fr1 nominal flow open
        fr1 = 1;
        fr2 = 0;
        fr3 = 0;
        // dfr open if water level rising (previous lower than current)
        dfr = (prev_state < curr_state) ? 1 : 0;
      end

      BETWEEN_S2_1: begin
        // fr1 and fr2 nominal flow open
        fr1 = 1;
        fr2 = 1;
        fr3 = 0;
        dfr = (prev_state < curr_state) ? 1 : 0;
      end

      BELOW_S1: begin
        // all nominal flow open
        fr1 = 1;
        fr2 = 1;
        fr3 = 1;
        dfr = 1; // always open supplemental valve below lowest sensor
      end

      default: begin
        fr1 = 1;
        fr2 = 1;
        fr3 = 1;
        dfr = 1;
      end
    endcase
  end

endmodule