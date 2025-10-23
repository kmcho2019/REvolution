module TopModule (
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

    reg [3:0] sec_ones, sec_tens;
    reg [3:0] min_ones, min_tens;
    reg [3:0] hour;  // 0-11 counter (12 represented as 0)
    reg pm_reg;
    wire counter_en = ena | reset;  // Enable counters during reset
    
    // Clock gating logic
    wire gated_clk = clk & counter_en;
    
    // Rollover conditions (parallel comparisons)
    wire sec_ones_max = (sec_ones == 4'd9);
    wire sec_tens_max = (sec_tens == 4'd5);
    wire min_ones_max = (min_ones == 4'd9);
    wire min_tens_max = (min_tens == 4'd5);
    
    wire sec_rollover = sec_ones_max && sec_tens_max;
    wire min_rollover = sec_rollover && min_ones_max && min_tens_max;
    
    // Seconds counter (direct BCD)
    always @(posedge gated_clk) begin
        if (reset) begin
            sec_ones <= 4'd0;
            sec_tens <= 4'd0;
        end else if (ena) begin
            if (sec_ones_max) begin
                sec_ones <= 4'd0;
                sec_tens <= sec_tens_max ? 4'd0 : sec_tens + 1;
            end else begin
                sec_ones <= sec_ones + 1;
            end
        end
    end

    // Minutes counter (direct BCD)
    always @(posedge gated_clk) begin
        if (reset) begin
            min_ones <= 4'd0;
            min_tens <= 4'd0;
        end else if (ena && sec_rollover) begin
            if (min_ones_max) begin
                min_ones <= 4'd0;
                min_tens <= min_tens_max ? 4'd0 : min_tens + 1;
            end else begin
                min_ones <= min_ones + 1;
            end
        end
    end

    // Hours counter (0-11) with PM logic
    always @(posedge gated_clk) begin
        if (reset) begin
            hour <= 4'd11;  // Represents 12 (12:00 AM)
            pm_reg <= 1'b0;
        end else if (ena && min_rollover) begin
            if (hour == 4'd11) begin
                hour <= 4'd0;
                pm_reg <= ~pm_reg;  // Toggle AM/PM at 11->12 transition
            end else begin
                hour <= hour + 1;
            end
        end
    end

    // Hour BCD conversion (4-bit lookup table)
    reg [7:0] hour_bcd;
    always @(*) begin
        case(hour)
            4'd0:  hour_bcd = 8'h12;  // 12
            4'd1:  hour_bcd = 8'h01;
            4'd2:  hour_bcd = 8'h02;
            4'd3:  hour_bcd = 8'h03;
            4'd4:  hour_bcd = 8'h04;
            4'd5:  hour_bcd = 8'h05;
            4'd6:  hour_bcd = 8'h06;
            4'd7:  hour_bcd = 8'h07;
            4'd8:  hour_bcd = 8'h08;
            4'd9:  hour_bcd = 8'h09;
            4'd10: hour_bcd = 8'h10;
            4'd11: hour_bcd = 8'h11;
            default: hour_bcd = 8'h12;
        endcase
    end

    // Output assignments
    assign ss = {sec_tens, sec_ones};
    assign mm = {min_tens, min_ones};
    assign hh = hour_bcd;
    assign pm = pm_reg;

endmodule