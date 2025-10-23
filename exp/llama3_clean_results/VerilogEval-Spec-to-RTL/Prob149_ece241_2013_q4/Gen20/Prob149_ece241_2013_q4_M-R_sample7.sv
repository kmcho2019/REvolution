module TopModule(
    input clk,
    input reset,
    input [2:0] s,
    output wire fr2,
    output wire fr1,
    output wire fr0,
    output wire dfr
);

// Intermediate signals for flow rates
wire above_high_sensor;
wire between_high_low_sensor;
wire between_low_lowest_sensor;
wire below_lowest_sensor;
reg [2:0] prev_s;

// Assign intermediate signals
assign above_high_sensor = s[2] && s[1] && s[0];
assign between_high_low_sensor = s[1] && s[0] && !s[2];
assign between_low_lowest_sensor = s[0] && !s[1] && !s[2];
assign below_lowest_sensor = !s[0] && !s[1] && !s[2];

// Assign output signals
assign fr2 = below_lowest_sensor;
assign fr1 = below_lowest_sensor || between_low_lowest_sensor;
assign fr0 = below_lowest_sensor || between_low_lowest_sensor || between_high_low_sensor;
assign dfr = (s[0] && !prev_s[0]) || (s[1] && !prev_s[1]) || (s[2] && !prev_s[2]);

// Synchronous reset and update previous sensor state
always @(posedge clk) begin
    if (reset) begin
        fr2 <= 1'b1;
        fr1 <= 1'b1;
        fr0 <= 1'b1;
        dfr <= 1'b1;
        prev_s <= 3'b000;
    end else begin
        prev_s <= s;
    end
end

endmodule