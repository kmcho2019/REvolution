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
    reg [5:0] sec_bin;  // 0-59
    reg [5:0] min_bin;  // 0-59
    reg [4:0] hr_bin;   // 0-23 (for easier AM/PM tracking)
    
    wire sec_ena = ena;
    wire min_ena = ena & (sec_bin == 6'd59);
    wire hr_ena = min_ena & (min_bin == 6'd59);
    
    // Binary counters
    always @(posedge clk) begin
        if (reset) begin
            sec_bin <= 6'd0;
            min_bin <= 6'd0;
            hr_bin <= 5'd0;
            pm_reg <= 1'b0;
        end else begin
            if (sec_ena) begin
                sec_bin <= (sec_bin == 6'd59) ? 6'd0 : sec_bin + 1;
            end
            
            if (min_ena) begin
                min_bin <= (min_bin == 6'd59) ? 6'd0 : min_bin + 1;
            end
            
            if (hr_ena) begin
                if (hr_bin == 5'd23) begin
                    hr_bin <= 5'd0;
                    pm_reg <= 1'b0;
                end else begin
                    hr_bin <= hr_bin + 1;
                    if (hr_bin == 5'd11) pm_reg <= 1'b1;
                end
            end
        end
    end

    // BCD conversion
    function [7:0] bin2bcd;
        input [5:0] bin;
        reg [3:0] tens, ones;
        begin
            tens = bin / 10;
            ones = bin % 10;
            bin2bcd = {tens, ones};
        end
    endfunction

    function [7:0] hr2bcd;
        input [4:0] hr;
        reg [3:0] tens, ones;
        begin
            // Convert 24-hour to 12-hour format
            if (hr == 5'd0) hr = 5'd12;
            else if (hr > 5'd12) hr = hr - 5'd12;
            
            tens = (hr > 9) ? 4'd1 : 4'd0;
            ones = hr % 10;
            hr2bcd = {tens, ones};
        end
    endfunction

    assign ss = bin2bcd(sec_bin);
    assign mm = bin2bcd(min_bin);
    assign hh = hr2bcd(hr_bin);
    assign pm = pm_reg & (hr_bin != 5'd12);  // PM except for 12:00-12:59

endmodule