module TopModule (
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

reg [31:0] seconds_total; // Total seconds since last reset

always @(posedge clk) begin
    if (reset) begin
        seconds_total <= 32'd0;
    end else if (ena) begin
        seconds_total <= seconds_total + 1;
    end
end

wire [4:0] hours_total = seconds_total / 3600; // Total hours since last reset
wire [5:0] minutes_total = (seconds_total / 60) % 60; // Minutes since last reset
wire [5:0] seconds_current = seconds_total % 60; // Current seconds

wire [3:0] hours_12 = (hours_total % 12) ? (hours_total % 12) : 4'd12; // 12-hour format
assign pm = (hours_total >= 12) ? 1'b1 : 1'b0;

assign hh = {4'd0, hours_12};
assign mm = {2'd0, minutes_total};
assign ss = {2'd0, seconds_current};

endmodule