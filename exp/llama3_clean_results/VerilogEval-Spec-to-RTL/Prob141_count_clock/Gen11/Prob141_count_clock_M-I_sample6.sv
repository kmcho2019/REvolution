module TopModule(
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

reg [31:0] time;

always @(posedge clk) begin
    if (reset) begin
        time <= 32'd0;
        pm <= 1'b0;
    end else if (ena) begin
        time <= time + 1;
        if (time == 32'd3600) begin // 1 hour
            time <= 32'd0;
            pm <= ~pm; // Toggle AM/PM
        end
    end
end

// Convert time to hours, minutes, and seconds
assign hh = (time[11:8] == 4'd0) ? {4'h0, time[7:4]} : {4'h1, time[7:4] - 4'd10};
assign mm = (time[5:0] < 6'd10) ? {4'h0, time[5:0]} : {4'h1, time[5:0] - 6'd10};
assign ss = (time[5:0] % 10'd60 < 6'd10) ? {4'h0, time[5:0] % 10'd60} : {4'h1, time[5:0] % 10'd60 - 6'd10};

endmodule