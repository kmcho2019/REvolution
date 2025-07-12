module TopModule(
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

// Intermediate signals for flow rates
wire above_high_sensor;
wire between_high_low_sensor;
wire between_low_lowest_sensor;
wire below_lowest_sensor;

// Assign intermediate signals
assign above_high_sensor = s[2] && s[1] && s[0];
assign between_high_low_sensor = s[1] && s[0] && !s[2];
assign between_low_lowest_sensor = s[0] && !s[1] && !s[2];
assign below_lowest_sensor = !s[0] && !s[1] && !s[2];

// Assign output signals
assign fr2 = ~above_high_sensor && ~between_high_low_sensor && ~between_low_lowest_sensor;
assign fr1 = ~above_high_sensor && ~between_high_low_sensor && below_lowest_sensor;
assign fr0 = ~above_high_sensor;
assign dfr = (~s[2] && ~s[1] && s[0]) || (s[2] && s[1] && s[0]);

// Synchronous reset
always @(posedge clk) begin
    if (reset) begin
        fr2 <= 1'b1;
        fr1 <= 1'b1;
        fr0 <= 1'b1;
        dfr <= 1'b1;
    end
end

endmodule