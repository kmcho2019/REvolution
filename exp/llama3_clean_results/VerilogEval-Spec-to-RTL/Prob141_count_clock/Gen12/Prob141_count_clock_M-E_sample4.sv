module bcd_counter(
    input clk,
    input reset,
    input ena,
    input [7:0] max_value,
    output reg [7:0] count
);

always @(posedge clk) begin
    if (reset) begin
        count <= 8'd0;
    end else if (ena) begin
        if (count == max_value) begin
            count <= 8'd0;
        end else begin
            count <= count + 1;
        end
    end
end

endmodule

module am_pm_controller(
    input [7:0] hour,
    output reg pm
);

always @(*) begin
    if (hour >= 8'd12) begin
        pm = 1'b1; // PM
    end else begin
        pm = 1'b0; // AM
    end
end

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

wire hh_ena;
wire mm_ena;

assign hh_ena = ena && ss == 8'd59 && mm == 8'd59;
assign mm_ena = ena && ss == 8'd59;

bcd_counter seconds_counter(
    .clk(clk),
    .reset(reset),
    .ena(ena),
    .max_value(8'd59),
    .count(ss)
);

bcd_counter minutes_counter(
    .clk(clk),
    .reset(reset),
    .ena(mm_ena),
    .max_value(8'd59),
    .count(mm)
);

bcd_counter hours_counter(
    .clk(clk),
    .reset(reset),
    .ena(hh_ena),
    .max_value(8'd11), // Max hour value in 12-hour format
    .count(hh)
);

am_pm_controller am_pm_ctrl(
    .hour(hh),
    .pm(pm)
);

// Correct hour value for 12-hour format
always @(posedge clk) begin
    if (reset) begin
        hh <= 8'd12; // 12 in BCD
    end else if (hh_ena) begin
        if (hh == 8'd12) begin
            hh <= 8'd1; // 1 in BCD
        end else begin
            hh <= hh + 1;
        end
    end
end

endmodule