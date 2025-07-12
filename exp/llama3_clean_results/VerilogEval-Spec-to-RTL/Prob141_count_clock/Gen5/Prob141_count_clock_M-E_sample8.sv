module TopModule (
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

reg [3:0] hours;
reg [5:0] minutes;
reg [5:0] seconds;
reg pm_flag;

// BCD encoding module
module bcd_encode(
    input [3:0] bin,
    output [3:0] bcd
);
    always @(bin) begin
        case (bin)
            4'd0: bcd = 4'b0000;
            4'd1: bcd = 4'b0001;
            4'd2: bcd = 4'b0010;
            4'd3: bcd = 4'b0011;
            4'd4: bcd = 4'b0100;
            4'd5: bcd = 4'b0101;
            4'd6: bcd = 4'b0110;
            4'd7: bcd = 4'b0111;
            4'd8: bcd = 4'b1000;
            4'd9: bcd = 4'b1001;
            default: bcd = 4'b0000;
        endcase
    end
endmodule

// Counter module
module counter(
    input clk,
    input reset,
    input ena,
    output [5:0] count
);
    reg [5:0] count_reg;
    always @(posedge clk) begin
        if (reset) begin
            count_reg <= 6'b000000;
        end else if (ena) begin
            if (count_reg == 6'b001001) begin
                count_reg <= 6'b000000;
            end else begin
                count_reg <= count_reg + 1;
            end
        end
    end
    assign count = count_reg;
endmodule

// Hours counter module
module hours_counter(
    input clk,
    input reset,
    input ena,
    output [3:0] hours
);
    reg [3:0] hours_reg;
    always @(posedge clk) begin
        if (reset) begin
            hours_reg <= 4'b0001;
        end else if (ena) begin
            if (hours_reg == 4'b1001) begin
                hours_reg <= 4'b0001;
            end else begin
                hours_reg <= hours_reg + 1;
            end
        end
    end
    assign hours = hours_reg;
endmodule

// State machine module
module state_machine(
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);
    reg [3:0] hours;
    reg [5:0] minutes;
    reg [5:0] seconds;
    reg pm_flag;
    hours_counter hc(clk, reset, ena, hours);
    counter mc(clk, reset, ena, minutes);
    counter sc(clk, reset, ena, seconds);
    always @(posedge clk) begin
        if (reset) begin
            pm_flag <= 1'b0;
        end else if (ena) begin
            if (seconds == 6'b001001) begin
                if (minutes == 6'b001001) begin
                    if (hours == 4'b1001) begin
                        hours <= 4'b0001;
                        pm_flag <= ~pm_flag;
                    end else begin
                        hours <= hours + 1;
                    end
                end
            end
        end
    end
    assign pm = pm_flag;
    assign hh = {4'b0000, hours};
    assign mm = {2'b00, minutes};
    assign ss = {2'b00, seconds};
endmodule

state_machine sm(clk, reset, ena, pm, hh, mm, ss);

endmodule