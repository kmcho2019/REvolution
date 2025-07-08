module TopModule (
  input clk,
  input reset,
  input [3:1] s,
  output reg fr3,
  output reg fr2,
  output reg fr1,
  output reg dfr
);

  // Enumerated water levels for clarity
  typedef enum reg [1:0] {
    BELOW_S1   = 2'b00,
    BETWEEN_S2_S1 = 2'b01,
    BETWEEN_S3_S2 = 2'b10,
    ABOVE_S3   = 2'b11
  } level_t;

  reg [1:0] current_level, previous_level;

  // Function to determine current water level from sensors
  function level_t get_level(input [3:1] sensors);
    begin
      if (sensors[3] && sensors[2] && sensors[1])
        get_level = ABOVE_S3;
      else if (sensors[2] && sensors[1] && !sensors[3])
        get_level = BETWEEN_S3_S2;
      else if (sensors[1] && !sensors[2] && !sensors[3])
        get_level = BETWEEN_S2_S1;
      else // no sensors asserted
        get_level = BELOW_S1;
    end
  endfunction

  // Combinational logic to set outputs based on current level and previous level
  always @(*) begin
    // Default all outputs off
    fr1 = 1'b0;
    fr2 = 1'b0;
    fr3 = 1'b0;
    dfr = 1'b0;

    case (current_level)
      ABOVE_S3: begin
        // all flows off
        fr1 = 1'b0; fr2 = 1'b0; fr3 = 1'b0;
        dfr = 1'b0;
      end
      BETWEEN_S3_S2: begin
        // fr1 on
        fr1 = 1'b1; fr2 = 1'b0; fr3 = 1'b0;
        // if rising level, supplemental flow valve on
        if (previous_level < current_level)
          dfr = 1'b1;
      end
      BETWEEN_S2_S1: begin
        // fr1, fr2 on
        fr1 = 1'b1; fr2 = 1'b1; fr3 = 1'b0;
        if (previous_level < current_level)
          dfr = 1'b1;
      end
      BELOW_S1: begin
        // fr1, fr2, fr3 on
        fr1 = 1'b1; fr2 = 1'b1; fr3 = 1'b1;
        // If rising level, supplemental flow valve on
        if (previous_level < current_level)
          dfr = 1'b1;
        else
          dfr = 1'b0;
      end
      default: begin
        // Default safe outputs, all valves open (like below s1)
        fr1 = 1'b1; fr2 = 1'b1; fr3 = 1'b1; dfr = 1'b0;
      end
    endcase
  end

  // Sequential logic to update current and previous level states
  always @(posedge clk) begin
    if (reset) begin
      // Reset to low water level for a long time: no sensors asserted,
      // all outputs asserted => BELOW_S1 state
      current_level <= BELOW_S1;
      previous_level <= BELOW_S1;
    end else begin
      // Update previous_level before updating current_level
      previous_level <= current_level;
      current_level <= get_level(s);
    end
  end

endmodule