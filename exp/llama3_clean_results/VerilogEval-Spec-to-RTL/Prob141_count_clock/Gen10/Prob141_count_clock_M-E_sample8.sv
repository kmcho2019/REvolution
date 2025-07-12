module hours_counter(
    input clk,
    input reset,
    input ena,
    output reg [3:0] hours,
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

assign hours = hours_reg;

endmodule

module minutes_counter(
    input clk,
    input reset,
    input ena,
    output reg [5:0] minutes
);

reg [5:0] minutes_reg;

always @(posedge clk) begin
    if (reset) begin
        minutes_reg <= 6'b000000; // Reset minutes to 00 (0 in BCD)
    end else if (ena) begin
        if (minutes_reg == 6'b010011) begin // 59 in BCD
            minutes_reg <= 6'b000000; // Wrap minutes to 00 (0 in BCD)
        end else begin
            minutes_reg <= minutes_reg + 1; // Increment minutes
        end
    end
end

assign minutes = minutes_reg;

endmodule

module seconds_counter(
    input clk,
    input reset,
    input ena,
    output reg [5:0] seconds
);

reg [5:0] seconds_reg;

always @(posedge clk) begin
    if (reset) begin
        seconds_reg <= 6'b000000; // Reset seconds to 00 (0 in BCD)
    end else if (ena) begin
        if (seconds_reg == 6'b010011) begin // 59 in BCD
            seconds_reg <= 6'b000000; // Wrap seconds to 00 (0 in BCD)
        end else begin
            seconds_reg <= seconds_reg + 1; // Increment seconds
        end
    end
end

assign seconds = seconds_reg;

endmodule

module control_module(
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

wire [3:0] hours;
wire [5:0] minutes;
wire [5:0] seconds;

hours_counter hours_counter_instance(
   .clk(clk),
   .reset(reset),
   .ena(ena),
   .hours(hours),
   .pm(pm)
);

minutes_counter minutes_counter_instance(
   .clk(clk),
   .reset(reset),
   .ena(ena),
   .minutes(minutes)
);

seconds_counter seconds_counter_instance(
   .clk(clk),
   .reset(reset),
   .ena(ena),
   .seconds(seconds)
);

always @(posedge clk) begin
    if (reset) begin
        hh <= 8'b00010001; // Reset hh to 01 (1 in BCD)
        mm <= 8'b00000000; // Reset mm to 00 (0 in BCD)
        ss <= 8'b00000000; // Reset ss to 00 (0 in BCD)
    end else begin
        hh <= {4'b0000, hours}; // Drive hh from hours
        mm <= {2'b00, minutes}; // Drive mm from minutes
        ss <= {2'b00, seconds}; // Drive ss from seconds
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

control_module control_module_instance(
   .clk(clk),
   .reset(reset),
   .ena(ena),
   .pm(pm),
   .hh(hh),
   .mm(mm),
   .ss(ss)
);

endmodule