module TopModule (
  input clk,
  input reset,
  input [3:1] s,
  output reg fr3,
  output reg fr2,
  output reg fr1,
  output reg dfr
);

// Water level encoding parameters
parameter ABOVE_S3 = 2'b11;
parameter BETWEEN_S3_S2 = 2'b10;
parameter BETWEEN_S2_S1 = 2'b01;
parameter BELOW_S1 = 2'b00;

reg [1:0] curr_water_level, prev_water_level;

// Priority encoder to determine current water level based on sensors
always @* begin
  case(s)
    3'b100: curr_water_level = ABOVE_S3;
    3'b110: curr_water_level = BETWEEN_S3_S2;
    3'b010: curr_water_level = BETWEEN_S2_S1;
    default: curr_water_level = BELOW_S1;
  endcase
end

// Initialize flow rates and supplemental flow valve on reset
always @(posedge clk or posedge reset) begin
  if (reset) begin
    fr3 <= 1'b1;
    fr2 <= 1'b1;
    fr1 <= 1'b1;
    dfr <= 1'b1;
    prev_water_level <= BELOW_S1;
  end
end

// Update flow rates and dfr based on water level changes
always @* begin
  case(curr_water_level)
    ABOVE_S3: begin
      fr3 = 1'b0;
      fr2 = 1'b0;
      fr1 = 1'b0;
      dfr = 1'b0;
    end
    BETWEEN_S3_S2: begin
      fr3 = 1'b1;
      fr2 = 1'b0;
      fr1 = 1'b0;
      if (prev_water_level < curr_water_level) begin
        dfr = 1'b0;
      end
    end
    BETWEEN_S2_S1: begin
      fr3 = 1'b1;
      fr2 = 1'b1;
      fr1 = 1'b0;
      if (prev_water_level < curr_water_level) begin
        dfr = 1'b1;
      end
    end
    BELOW_S1: begin
      fr3 = 1'b1;
      fr2 = 1'b1;
      fr1 = 1'b1;
      if (prev_water_level < curr_water_level) begin
        dfr = 1'b1;
      end
    end
  endcase
end

// Update previous water level for next cycle
always @(posedge clk) begin
  prev_water_level <= curr_water_level;
end

endmodule