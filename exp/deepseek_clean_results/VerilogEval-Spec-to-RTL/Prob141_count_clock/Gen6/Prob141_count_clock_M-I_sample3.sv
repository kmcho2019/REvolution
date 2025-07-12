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
    reg [3:0] hour;  // 1-12 counter
    reg pm_reg;
    reg sec_rollover, min_rollover;
    reg [7:0] hh_reg;

    // Registered rollover signals
    always @(posedge clk) begin
        if (reset) begin
            sec_rollover <= 1'b0;
            min_rollover <= 1'b0;
        end else if (ena) begin
            sec_rollover <= (sec_ones == 4'd9) && (sec_tens == 4'd5);
            min_rollover <= sec_rollover && (min_ones == 4'd9) && (min_tens == 4'd5);
        end else begin
            sec_rollover <= 1'b0;
            min_rollover <= 1'b0;
        end
    end

    // Shared increment logic for seconds and minutes
    function [7:0] bcd_increment;
        input [3:0] ones;
        input [3:0] tens;
        input [3:0] max_tens;
        begin
            if (ones == 4'd9) begin
                bcd_increment[3:0] = 4'd0;
                bcd_increment[7:4] = (tens == max_tens) ? 4'd0 : tens + 1;
            end else begin
                bcd_increment[3:0] = ones + 1;
                bcd_increment[7:4] = tens;
            end
        end
    endfunction

    // Seconds counter
    always @(posedge clk) begin
        if (reset) begin
            {sec_tens, sec_ones} <= 8'h00;
        end else if (ena) begin
            {sec_tens, sec_ones} <= bcd_increment(sec_ones, sec_tens, 4'd5);
        end
    end

    // Minutes counter
    always @(posedge clk) begin
        if (reset) begin
            {min_tens, min_ones} <= 8'h00;
        end else if (sec_rollover) begin
            {min_tens, min_ones} <= bcd_increment(min_ones, min_tens, 4'd5);
        end
    end

    // Hours counter with pre-computed BCD
    always @(posedge clk) begin
        if (reset) begin
            hour <= 4'd12;
            pm_reg <= 1'b0;
            hh_reg <= 8'h12;
        end else if (min_rollover) begin
            if (hour == 4'd12) begin
                hour <= 4'd1;
                hh_reg <= 8'h01;
            end else begin
                hour <= hour + 1;
                hh_reg <= (hour == 4'd9) ? 8'h10 : {1'b0, hour + 1};
            end
            
            // PM toggles only when hour changes from 11 to 12
            if (hour == 4'd11) pm_reg <= ~pm_reg;
        end
    end

    assign ss = {sec_tens, sec_ones};
    assign mm = {min_tens, min_ones};
    assign hh = hh_reg;
    assign pm = pm_reg;

endmodule