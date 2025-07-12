module hours_counter(
    input clk,
    input reset,
    input ena,
    output reg [7:0] hh,
    output reg pm
);

reg [3:0] hours_reg;

always @(posedge clk) begin
    if (reset) begin
        hours_reg <= 4'b1001; // Reset hours to 01 (1 in BCD)
        pm <= 1'b0; // Reset to AM
    end else if (ena) begin
        if (hours_reg == 4'b1000) begin // 12 in BCD
            hours_reg <= 4'b1001; // Wrap hours to 01 (1 in BCD)
            pm <= ~pm; // Toggle AM/PM
        end else begin
            hours_reg <= hours_reg + 1; // Increment hours
        end
    end
end

assign hh = {4'b0000, hours_reg}; // Drive hh from hours_reg

endmodule

module minutes_seconds_counter(
    input clk,
    input reset,
    input ena,
    output reg [7:0] count
);

reg [5:0] count_reg;

always @(posedge clk) begin
    if (reset) begin
        count_reg <= 6'b000000; // Reset count to 00 (0 in BCD)
    end else if (ena) begin
        if (count_reg == 6'b010011) begin // 59 in BCD
            count_reg <= 6'b000000; // Wrap count to 00 (0 in BCD)
        end else begin
            count_reg <= count_reg + 1; // Increment count
        end
    end
end

assign count = {2'b00, count_reg}; // Drive count from count_reg

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

hours_counter hours_counter_instance(
    .clk(clk),
    .reset(reset),
    .ena(ena),
    .hh(hh),
    .pm(pm)
);

minutes_seconds_counter minutes_counter_instance(
    .clk(clk),
    .reset(reset),
    .ena(ena),
    .count(mm)
);

minutes_seconds_counter seconds_counter_instance(
    .clk(clk),
    .reset(reset),
    .ena(ena),
    .count(ss)
);

endmodule