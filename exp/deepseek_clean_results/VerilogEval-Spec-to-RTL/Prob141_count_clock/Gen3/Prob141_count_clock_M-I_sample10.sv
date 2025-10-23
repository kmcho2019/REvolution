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
    reg [3:0] hr_cnt;  // 1-12 hour counter
    reg pm_reg;
    
    wire sec_inc = ena;
    wire min_inc = ena && (sec_ones == 4'd9) && (sec_tens == 4'd5);
    wire hr_inc = ena && (min_ones == 4'd9) && (min_tens == 4'd5) && (sec_ones == 4'd9) && (sec_tens == 4'd5);

    // BCD increment helper function
    function [7:0] bcd_inc;
        input [7:0] bcd;
        input max;
        begin
            if (bcd[3:0] == 4'd9) begin
                bcd[3:0] = 4'd0;
                bcd[7:4] = max ? 4'd0 : bcd[7:4] + 1;
            end else begin
                bcd[3:0] = bcd[3:0] + 1;
            end
            bcd_inc = bcd;
        end
    endfunction

    // Seconds counter
    always @(posedge clk) begin
        if (reset) begin
            {sec_tens, sec_ones} <= 8'h00;
        end else if (sec_inc) begin
            {sec_tens, sec_ones} <= bcd_inc({sec_tens, sec_ones}, 5);
        end
    end

    // Minutes counter
    always @(posedge clk) begin
        if (reset) begin
            {min_tens, min_ones} <= 8'h00;
        end else if (min_inc) begin
            {min_tens, min_ones} <= bcd_inc({min_tens, min_ones}, 5);
        end
    end

    // Hours counter and PM detection
    always @(posedge clk) begin
        if (reset) begin
            hr_cnt <= 4'd12;
            pm_reg <= 1'b0;
        end else if (hr_inc) begin
            if (hr_cnt == 4'd12)
                hr_cnt <= 4'd1;
            else
                hr_cnt <= hr_cnt + 1;
                
            // Toggle PM at 11->12 transition
            if (hr_cnt == 4'd11)
                pm_reg <= ~pm_reg;
        end
    end

    // BCD conversion for hours
    wire [7:0] hr_bcd = (hr_cnt < 10) ? {4'd0, hr_cnt} : {4'd1, hr_cnt - 4'd10};

    assign ss = {sec_tens, sec_ones};
    assign mm = {min_tens, min_ones};
    assign hh = hr_bcd;
    assign pm = pm_reg;

endmodule