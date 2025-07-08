module TopModule (
  input clk,
  input reset,
  input [3:1] s,
  output reg fr3,
  output reg fr2,
  output reg fr1,
  output reg dfr
);

// Define states encoding water level zones
localparam BELOW_S1      = 2'b00;
localparam BETWEEN_S2_S1 = 2'b01;
localparam BETWEEN_S3_S2 = 2'b10;
localparam ABOVE_S3      = 2'b11;

reg [1:0] current_zone, prev_zone;

// Function to determine zone from sensors
function [1:0] get_zone(input [3:1] sensors);
  begin
    if (sensors[3] && sensors[2] && sensors[1])
      get_zone = ABOVE_S3;
    else if (sensors[2] && sensors[1] && ~sensors[3])
      get_zone = BETWEEN_S3_S2;
    else if (sensors[1] && ~sensors[2] && ~sensors[3])
      get_zone = BETWEEN_S2_S1;
    else
      get_zone = BELOW_S1;
  end
endfunction

always @(posedge clk) begin
  if (reset) begin
    // Reset to lowest level: below s[1], all flow valves open and supplemental flow on
    current_zone <= BELOW_S1;
    prev_zone <= BELOW_S1;
    fr1 <= 1'b1;
    fr2 <= 1'b1;
    fr3 <= 1'b1;
    dfr <= 1'b1;
  end else begin
    // Update zones
    current_zone <= get_zone(s);
    prev_zone <= current_zone;

    // Determine if water level is rising (prev_zone < current_zone)
    // Use a temporary variable to hold previous zone for dfr calculation
    // Since prev_zone is assigned current_zone in same clock, store prev_zone first
  end
end

// dfr logic: must compare prev_zone and current_zone from previous cycle
// So implement a separate always block to handle outputs based on current_zone and prev_zone stored from previous clock

reg [1:0] zone_now, zone_prev;

always @(posedge clk) begin
  if (reset) begin
    zone_now <= BELOW_S1;
    zone_prev <= BELOW_S1;
  end else begin
    zone_prev <= zone_now;
    zone_now <= get_zone(s);
  end
end

always @(*) begin
  // Default all off
  fr1 = 1'b0;
  fr2 = 1'b0;
  fr3 = 1'b0;
  dfr = 1'b0;

  case(zone_now)
    ABOVE_S3: begin
      // No flow valves open
      fr1 = 1'b0;
      fr2 = 1'b0;
      fr3 = 1'b0;
      dfr = 1'b0;
    end
    BETWEEN_S3_S2: begin
      // fr1 only
      fr1 = 1'b1;
      fr2 = 1'b0;
      fr3 = 1'b0;
      // supplemental if rising
      dfr = (zone_prev < zone_now) ? 1'b1 : 1'b0;
    end
    BETWEEN_S2_S1: begin
      // fr1 and fr2
      fr1 = 1'b1;
      fr2 = 1'b1;
      fr3 = 1'b0;
      dfr = (zone_prev < zone_now) ? 1'b1 : 1'b0;
    end
    BELOW_S1: begin
      // fr1, fr2, fr3 all on
      fr1 = 1'b1;
      fr2 = 1'b1;
      fr3 = 1'b1;
      dfr = 1'b1; // Always supplemental on at lowest level, per spec "all four outputs asserted"
    end
    default: begin
      fr1 = 1'b0;
      fr2 = 1'b0;
      fr3 = 1'b0;
      dfr = 1'b0;
    end
  endcase
end

endmodule