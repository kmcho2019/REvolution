module TopModule (
  input  clk,
  input  reset,
  input [2:0] s,
  output reg fr2,
  output reg fr1,
  output reg fr0,
  output reg dfr
);

reg [2:0] prev_s;

always @(posedge clk or posedge reset) begin
  if (reset) begin
    // Reset to state equivalent to water level being low for a long time
    fr2 <= 1'b1;
    fr1 <= 1'b1;
    fr0 <= 1'b1;
    dfr <= 1'b1;
    prev_s <= 3'b000;
  end else begin
    prev_s <= s;
    
    if (s == 3'b111) begin // Above the highest sensor
      fr2 <= 1'b0;
      fr1 <= 1'b0;
      fr0 <= 1'b0;
      dfr <= 1'b0;
    end else if (s == 3'b110) begin // Between the highest and middle sensors
      fr2 <= 1'b0;
      fr1 <= 1'b0;
      fr0 <= 1'b1;
      if (prev_s < s) begin
        dfr <= 1'b1;
      end else begin
        dfr <= 1'b0;
      end
    end else if (s == 3'b100) begin // Between the middle and lowest sensors
      fr2 <= 1'b0;
      fr1 <= 1'b1;
      fr0 <= 1'b1;
      if (prev_s < s) begin
        dfr <= 1'b1;
      end else begin
        dfr <= 1'b0;
      end
    end else if (s == 3'b001) begin // Between the lowest sensor and below
      fr2 <= 1'b1;
      fr1 <= 1'b1;
      fr0 <= 1'b1;
      if (prev_s < s) begin
        dfr <= 1'b1;
      end else begin
        dfr <= 1'b0;
      end
    end else begin // Below the lowest sensor
      fr2 <= 1'b1;
      fr1 <= 1'b1;
      fr0 <= 1'b1;
      dfr <= 1'b1;
    end
  end
end

endmodule