module bcd_counter(
    input clk,
    input reset,
    input ena,
    output reg [7:0] count
);

always @(posedge clk) begin
    if (reset) begin
        count <= 8'd0;
    end else if (ena) begin
        if (count == 8'd59) begin
            count <= 8'd0;
        end else begin
            count <= count + 1;
        end
    end
end

endmodule

module hours_counter(
    input clk,
    input reset,
    input ena,
    input pm,
    output reg [7:0] hours,
    output reg pm_out
);

reg [7:0] count;

always @(posedge clk) begin
    if (reset) begin
        count <= 8'd12; // 12 in BCD
        pm_out <= 1'b0; // AM
    end else if (ena) begin
        if (count == 8'd12) begin
            if (pm) begin
                count <= 8'd1; // 1 in BCD
                pm_out <= 1'b0; // AM
            end else begin
                count <= 8'd1; // 1 in BCD
                pm_out <= 1'b1; // PM
            end
        end else if (count == 8'd1 && pm == 1'b0) begin
            count <= 8'd2; // 2 in BCD
            pm_out <= pm;
        end else if (count == 8'd11 && pm == 1'b1) begin
            count <= 8'd12; // 12 in BCD
            pm_out <= pm;
        end else begin
            count <= count + 1;
            pm_out <= pm;
        end
    end
end

assign hours = count;

endmodule

module TopModule(
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

reg [7:0] seconds;
reg [7:0] minutes;
reg [7:0] hours_count;
reg pm_out;

bcd_counter seconds_counter(
    .clk(clk),
    .reset(reset),
    .ena(ena),
    .count(seconds)
);

bcd_counter minutes_counter(
    .clk(clk),
    .reset(reset),
    .ena(seconds == 8'd59 ? 1'b1 : 1'b0),
    .count(minutes)
);

hours_counter hours_module(
    .clk(clk),
    .reset(reset),
    .ena(minutes == 8'd59 ? 1'b1 : 1'b0),
    .pm(pm),
    .hours(hours_count),
    .pm_out(pm_out)
);

always @(posedge clk) begin
    if (reset) begin
        pm <= 1'b0;
    end else if (minutes == 8'd59 && seconds == 8'd59) begin
        pm <= pm_out;
    end
end

assign hh = hours_count;
assign mm = minutes;
assign ss = seconds;

endmodule