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
    reg [3:0] hour_ones;  // 1-9, 0, 1-2
    reg hour_tens;        // 0 or 1
    reg pm_reg;
    reg sec_rollover, min_rollover;
    reg sec_rollover_d, min_rollover_d;

    // Shared increment logic for seconds and minutes
    function [7:0] bcd_increment;
        input [7:0] bcd;
        input [3:0] max_ones;
        input [3:0] max_tens;
        reg [3:0] ones, tens;
        begin
            ones = bcd[3:0];
            tens = bcd[7:4];
            
            if (ones == max_ones) begin
                ones = 4'd0;
                tens = (tens == max_tens) ? 4'd0 : tens + 1;
            end else begin
                ones = ones + 1;
            end
            
            bcd_increment = {tens, ones};
        end
    endfunction

    // Rollover detection (registered)
    always @(posedge clk) begin
        if (reset) begin
            sec_rollover <= 1'b0;
            min_rollover <= 1'b0;
            sec_rollover_d <= 1'b0;
            min_rollover_d <= 1'b0;
        end else begin
            sec_rollover_d <= ena && (sec_ones == 4'd9) && (sec_tens == 4'd5);
            min_rollover_d <= sec_rollover_d && (min_ones == 4'd9) && (min_tens == 4'd5);
            sec_rollover <= sec_rollover_d;
            min_rollover <= min_rollover_d;
        end
    end

    // Seconds counter
    always @(posedge clk) begin
        if (reset) begin
            {sec_tens, sec_ones} <= 8'h00;
        end else if (ena) begin
            {sec_tens, sec_ones} <= bcd_increment({sec_tens, sec_ones}, 4'd9, 4'd5);
        end
    end

    // Minutes counter
    always @(posedge clk) begin
        if (reset) begin
            {min_tens, min_ones} <= 8'h00;
        end else if (sec_rollover) begin
            {min_tens, min_ones} <= bcd_increment({min_tens, min_ones}, 4'd9, 4'd5);
        end
    end

    // Hours counter and PM logic (clock-gated)
    always @(posedge clk) begin
        if (reset) begin
            hour_tens <= 1'b1;
            hour_ones <= 4'd2;  // 12
            pm_reg <= 1'b0;
        end else if (min_rollover) begin
            // Handle hour increment with direct BCD encoding
            if ({hour_tens, hour_ones} == 5'b10010) begin  // 12
                hour_tens <= 1'b0;
                hour_ones <= 4'd1;  // 1
            end else if (hour_ones == 4'd9) begin
                hour_tens <= 1'b1;
                hour_ones <= 4'd0;
            end else begin
                hour_ones <= hour_ones + 1;
            end
            
            // PM toggle only when hour changes from 11 to 12
            if ({hour_tens, hour_ones} == 5'b01001) begin  // 9 (11 in BCD)
                pm_reg <= ~pm_reg;
            end
        end
    end

    // Output assignments
    assign ss = {sec_tens, sec_ones};
    assign mm = {min_tens, min_ones};
    assign hh = {hour_tens, 3'b0, hour_ones};
    assign pm = pm_reg;

endmodule