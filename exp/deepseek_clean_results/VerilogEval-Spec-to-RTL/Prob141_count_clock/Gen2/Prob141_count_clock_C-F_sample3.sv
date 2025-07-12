module TopModule (
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

    // Separate BCD digits for each counter
    reg [3:0] sec_ones, sec_tens;
    reg [3:0] min_ones, min_tens;
    reg [3:0] hr_ones, hr_tens;
    reg pm_reg;
    
    // Cascade enable signals
    wire min_ena, hr_ena;
    
    // Seconds counter
    always @(posedge clk) begin
        if (reset) begin
            sec_ones <= 4'd0;
            sec_tens <= 4'd0;
        end else if (ena) begin
            if (sec_ones == 4'd9) begin
                sec_ones <= 4'd0;
                if (sec_tens == 4'd5)
                    sec_tens <= 4'd0;
                else
                    sec_tens <= sec_tens + 1;
            end else begin
                sec_ones <= sec_ones + 1;
            end
        end
    end
    
    assign min_ena = ena & (sec_ones == 4'd9) & (sec_tens == 4'd5);
    
    // Minutes counter
    always @(posedge clk) begin
        if (reset) begin
            min_ones <= 4'd0;
            min_tens <= 4'd0;
        end else if (min_ena) begin
            if (min_ones == 4'd9) begin
                min_ones <= 4'd0;
                if (min_tens == 4'd5)
                    min_tens <= 4'd0;
                else
                    min_tens <= min_tens + 1;
            end else begin
                min_ones <= min_ones + 1;
            end
        end
    end
    
    assign hr_ena = min_ena & (min_ones == 4'd9) & (min_tens == 4'd5);
    
    // Hours counter and PM indicator
    always @(posedge clk) begin
        if (reset) begin
            hr_ones <= 4'd2;
            hr_tens <= 4'd1;
            pm_reg <= 1'b0;
        end else if (hr_ena) begin
            // Handle hour increment
            if (hr_ones == 4'd2 && hr_tens == 4'd1) begin
                // 12 → 1
                hr_ones <= 4'd1;
                hr_tens <= 4'd0;
            end else if (hr_ones == 4'd9) begin
                // 9 → 10
                hr_ones <= 4'd0;
                hr_tens <= hr_tens + 1;
            end else begin
                hr_ones <= hr_ones + 1;
            end
            
            // Toggle PM only at 11:59:59 → 12:00:00
            if (hr_ones == 4'd1 && hr_tens == 4'd1)
                pm_reg <= ~pm_reg;
        end
    end

    assign ss = {sec_tens, sec_ones};
    assign mm = {min_tens, min_ones};
    assign hh = {hr_tens, hr_ones};
    assign pm = pm_reg;

endmodule