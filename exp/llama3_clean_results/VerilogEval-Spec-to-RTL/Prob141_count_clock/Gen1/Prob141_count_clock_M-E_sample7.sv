// Counter module for hours, minutes, and seconds
module BCDCounter(
    input clk,
    input reset,
    input ena,
    output reg [3:0] tens,
    output reg [3:0] ones
);

reg [3:0] tens_reg;
reg [3:0] ones_reg;

always @(posedge clk) begin
    if (reset) begin
        tens_reg <= 4'd0;
        ones_reg <= 4'd0;
    end else if (ena) begin
        if (ones_reg == 4'd9) begin
            ones_reg <= 4'd0;
            if (tens_reg == 4'd5) begin
                tens_reg <= 4'd0;
            end else begin
                tens_reg <= tens_reg + 1'b1;
            end
        end else begin
            ones_reg <= ones_reg + 1'b1;
        end
    end
end

assign tens = tens_reg;
assign ones = ones_reg;

endmodule

// AM/PM indicator module
module AMPMIndicator(
    input clk,
    input reset,
    input hour_tens,
    input hour_ones,
    output reg pm
);

reg pm_reg;

always @(posedge clk) begin
    if (reset) begin
        pm_reg <= 1'b0;
    end else if (hour_tens == 4'd1 && hour_ones == 4'd2) begin
        pm_reg <= 1'b1;
    end else if (hour_tens == 4'd0 && hour_ones == 4'd1) begin
        pm_reg <= 1'b0;
    end
end

assign pm = pm_reg;

endmodule

// TopModule
module TopModule(
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

wire hour_ena;
wire min_ena;
wire sec_ena;

assign hour_ena = (mm == 8'b00_00) && (ss == 8'b00_00) && ena;
assign min_ena = (ss == 8'b00_00) && ena;
assign sec_ena = ena;

BCDCounter hour_counter(
    .clk(clk),
    .reset(reset),
    .ena(hour_ena),
    .tens(hh[7:4]),
    .ones(hh[3:0])
);

BCDCounter min_counter(
    .clk(clk),
    .reset(reset),
    .ena(min_ena),
    .tens(mm[7:4]),
    .ones(mm[3:0])
);

BCDCounter sec_counter(
    .clk(clk),
    .reset(reset),
    .ena(sec_ena),
    .tens(ss[7:4]),
    .ones(ss[3:0])
);

AMPMIndicator ampm_indicator(
    .clk(clk),
    .reset(reset),
    .hour_tens(hh[7:4]),
    .hour_ones(hh[3:0]),
    .pm(pm)
);

endmodule