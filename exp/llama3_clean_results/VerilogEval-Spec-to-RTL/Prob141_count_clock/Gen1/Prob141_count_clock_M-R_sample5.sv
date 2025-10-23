// Define a module for a BCD counter
module bcd_counter (
    input clk,
    input reset,
    input ena,
    input [7:0] max_value,
    output [7:0] count
);

reg [7:0] count_reg;

always @(posedge clk) begin
    if (reset) begin
        count_reg <= 8'b00000000;
    end else if (ena) begin
        if (count_reg == max_value) begin
            count_reg <= 8'b00000000;
        end else begin
            count_reg <= count_reg + 1;
        end
    end
end

assign count = count_reg;

endmodule

// Define the TopModule
module TopModule (
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

// Instantiate the BCD counters
wire sec_ena;
wire min_ena;
wire hour_ena;
wire pm_ena;

assign sec_ena = ena;
assign min_ena = (ss == 8'b01011001) ? 1'b1 : 1'b0;
assign hour_ena = (mm == 8'b01011001 && ss == 8'b01011001) ? 1'b1 : 1'b0;
assign pm_ena = (hh == 8'b00010010 && mm == 8'b00000000 && ss == 8'b00000000) ? 1'b1 : 1'b0;

bcd_counter seconds_counter (
    .clk(clk),
    .reset(reset),
    .ena(sec_ena),
    .max_value(8'b01011001),
    .count(ss)
);

bcd_counter minutes_counter (
    .clk(clk),
    .reset(reset),
    .ena(min_ena),
    .max_value(8'b01011001),
    .count(mm)
);

reg [7:0] hours_reg;
reg pm_reg;

always @(posedge clk) begin
    if (reset) begin
        hours_reg <= 8'b00010010; // 12 in BCD
        pm_reg <= 1'b0; // AM
    end else if (hour_ena) begin
        if (hours_reg == 8'b00010111) begin // 11 in BCD
            hours_reg <= 8'b00010010; // 12 in BCD
            pm_reg <= 1'b1; // PM
        end else if (hours_reg == 8'b00010010) begin // 12 in BCD
            hours_reg <= 8'b00010001; // 01 in BCD
            pm_reg <= 1'b0; // AM
        end else begin
            hours_reg <= hours_reg + 1;
        end
    end else if (pm_ena) begin
        pm_reg <= ~pm_reg;
    end
end

assign hh = hours_reg;
assign pm = pm_reg;

endmodule