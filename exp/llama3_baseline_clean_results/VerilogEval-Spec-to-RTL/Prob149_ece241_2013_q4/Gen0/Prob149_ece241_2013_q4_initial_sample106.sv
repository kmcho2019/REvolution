module TopModule(
    input  clk,
    input  reset,
    input  [2:0] s,
    output fr2,
    output fr1,
    output fr0,
    output dfr
);

// Define the possible states of the water level
wire above_s2 = s[2] & s[1] & s[0];
wire between_s2_s1 = s[1] & s[0] & ~s[2];
wire between_s1_s0 = s[0] & ~s[1] & ~s[2];
wire below_s0 = ~s[0] & ~s[1] & ~s[2];

// Determine the nominal flow rate based on the current state
assign fr2 = below_s0;
assign fr1 = between_s1_s0 | below_s0;
assign fr0 = between_s2_s1 | between_s1_s0 | below_s0;

// Use a 2-bit register to keep track of the previous state of the sensors
reg [2:0] prev_s;
always @(posedge clk) begin
    if (reset) begin
        prev_s <= 3'b000; // Reset to low water level state
    end else begin
        prev_s <= s;
    end
end

// Determine if the water level is increasing or decreasing
wire level_increasing = (~prev_s[0] & s[0]) | (~prev_s[1] & s[1]) | (~prev_s[2] & s[2]);

// Control the Supplemental flow valve based on the level change
assign dfr = level_increasing & (between_s2_s1 | between_s1_s0 | below_s0);

endmodule