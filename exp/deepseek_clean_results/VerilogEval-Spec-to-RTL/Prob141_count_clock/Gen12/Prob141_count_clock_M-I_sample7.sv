module TopModule (
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

    reg pm_reg;
    reg [3:0] ss_tens, ss_ones;
    reg [3:0] mm_tens, mm_ones;
    reg [3:0] hh_tens, hh_ones;

    // Enable signals (independent generation)
    wire sec_inc = ena;
    wire min_inc = (ss_tens == 4'd5) && (ss_ones == 4'd9) && sec_inc;
    wire hour_inc = (mm_tens == 4'd5) && (mm_ones == 4'd9) && min_inc;

    // Shared BCD increment function
    function [7:0] bcd_inc;
        input [3:0] tens;
        input [3:0] ones;
        input max_tens;
        begin
            if (ones == 4'd9) begin
                bcd_inc = {tens + 4'd1, 4'd0};
                if (tens == max_tens) bcd_inc = 8'd0;
            end else begin
                bcd_inc = {tens, ones + 4'd1};
            end
        end
    endfunction

    // Seconds counter (00-59 BCD)
    always @(posedge clk) begin
        if (reset) begin
            {ss_tens, ss_ones} <= 8'h00;
        end else if (sec_inc) begin
            {ss_tens, ss_ones} <= bcd_inc(ss_tens, ss_ones, 4'd5);
        end
    end

    // Minutes counter (00-59 BCD)
    always @(posedge clk) begin
        if (reset) begin
            {mm_tens, mm_ones} <= 8'h00;
        end else if (min_inc) begin
            {mm_tens, mm_ones} <= bcd_inc(mm_tens, mm_ones, 4'd5);
        end
    end

    // Hours counter (01-12 BCD) and PM indicator
    always @(posedge clk) begin
        if (reset) begin
            {hh_tens, hh_ones} <= 8'h12;
            pm_reg <= 1'b0;
        end else if (hour_inc) begin
            // Handle hour increment with special 12->1 case
            if ({hh_tens, hh_ones} == 8'h12) begin
                {hh_tens, hh_ones} <= 8'h01;
            end else begin
                {hh_tens, hh_ones} <= bcd_inc(hh_tens, hh_ones, 4'd1);
            end

            // Simplified PM toggle (only at 11->12 transition)
            if ({hh_tens, hh_ones} == 8'h11) pm_reg <= ~pm_reg;
        end
    end

    // Output assignments
    assign pm = pm_reg;
    assign ss = {ss_tens, ss_ones};
    assign mm = {mm_tens, mm_ones};
    assign hh = {hh_tens, hh_ones};

endmodule