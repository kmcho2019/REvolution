module TopModule (
  input clk,
  input reset,
  input [3:1] s,
  output reg fr3,
  output reg fr2,
  output reg fr1,
  output reg dfr
);

  // Define states for water levels
  typedef enum reg [1:0] {
    BELOW = 2'b00,       // no sensors asserted
    BETWEEN_1_2 = 2'b01, // s[1] asserted only
    BETWEEN_2_3 = 2'b10, // s[1] and s[2] asserted
    ABOVE = 2'b11        // s[1], s[2], s[3] asserted
  } state_t;

  reg [1:0] current_state, previous_state;

  // Determine next state based on sensors
  function state_t sensor_to_state(input [3:1] sensors);
    begin
      casez (sensors)
        3'b111: sensor_to_state = ABOVE;
        3'b110: sensor_to_state = BETWEEN_2_3;
        3'b100: sensor_to_state = BETWEEN_1_2;
        3'b000: sensor_to_state = BELOW;
        default: begin
          // Handle other combinations not specified - treat conservatively:
          // s[1] asserted alone or in combination means BETWEEN_1_2 or BETWEEN_2_3
          // We'll fallback to the closest match:
          if (sensors[1]) begin
            if (sensors[2]) sensor_to_state = BETWEEN_2_3;
            else sensor_to_state = BETWEEN_1_2;
          end else begin
            sensor_to_state = BELOW;
          end
        end
      endcase
    end
  endfunction

  // On reset, state is BELOW (no sensors asserted)
  // and all outputs asserted (fr1, fr2, fr3, dfr = 1)
  // On clock, update states and outputs
  always @(posedge clk) begin
    if (reset) begin
      current_state <= BELOW;
      previous_state <= BELOW;
      fr1 <= 1'b1;
      fr2 <= 1'b1;
      fr3 <= 1'b1;
      dfr <= 1'b1;
    end else begin
      previous_state <= current_state;
      current_state <= sensor_to_state(s);

      // Determine outputs based on current_state
      case (sensor_to_state(s))
        ABOVE: begin
          // Above s[3]: all flow valves closed, no supplemental valve
          fr1 <= 1'b0;
          fr2 <= 1'b0;
          fr3 <= 1'b0;
        end
        BETWEEN_2_3: begin
          // Between s[3] and s[2]: fr1 only nominal
          fr1 <= 1'b1;
          fr2 <= 1'b0;
          fr3 <= 1'b0;
        end
        BETWEEN_1_2: begin
          // Between s[2] and s[1]: fr1 and fr2 nominal
          fr1 <= 1'b1;
          fr2 <= 1'b1;
          fr3 <= 1'b0;
        end
        BELOW: begin
          // Below s[1]: fr1, fr2, fr3 all nominal
          fr1 <= 1'b1;
          fr2 <= 1'b1;
          fr3 <= 1'b1;
        end
        default: begin
          // Default safe outputs (all open)
          fr1 <= 1'b1;
          fr2 <= 1'b1;
          fr3 <= 1'b1;
        end
      endcase

      // Determine dfr (supplemental valve)
      // dfr is 1 if the water level is rising: previous_state < current_state
      // since states are ordered from low to high level:
      // BELOW(0) < BETWEEN_1_2(1) < BETWEEN_2_3(2) < ABOVE(3)
      if (current_state > previous_state)
        dfr <= 1'b1;
      else
        dfr <= 1'b0;
    end
  end

endmodule