module TopModule (
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

    // Registers for counters
    reg [3:0] sec_ones, sec_tens;
    reg [3:0] min_ones, min_tens;
    reg [3:0] hour;
    reg pm_reg;
    
    // Intermediate rollover signals
    wire sec_ones_roll = (sec_ones == 4'd9);
    wire sec_tens_roll = (sec_tens == 4'd5);
    wire min_ones_roll = (min_ones == 4'd9);
    wire min_tens_roll = (min_tens == 4'd5);
    
    // Registered rollover signals
    reg sec_rollover;
    reg min_rollover;
    
    // Seconds counter logic
    always @(posedge clk) begin
        if (reset) begin
            sec_ones <= 4'd0;
            sec_tens <= 4'd0;
        end else if (ena) begin
            if (sec_ones_roll) begin
                sec_ones <= 4'd0;
                if (sec_tens_roll)
                    sec_tens <= 4'd0;
                else
                    sec_tens <= sec_tens + 1;
            end else begin
                sec_ones <= sec_ones + 1;
            end
        end
    end
    
    // Minutes counter logic
    always @(posedge clk) begin
        if (reset) begin
            min_ones <= 4'd0;
            min_tens <= 4'd0;
        end else if (ena && sec_ones_roll && sec_tens_roll) begin
            if (min_ones_roll) begin
                min_ones <= 4'd0;
                if (min_tens_roll)
                    min_tens <= 4'd0;
                else
                    min_tens <= min_tens + 1;
            end else begin
                min_ones <= min_ones + 1;
            end
        end
    end
    
    // Rollover signal generation
    always @(posedge clk) begin
        sec_rollover <= ena && sec_ones_roll && sec_tens_roll;
        min_rollover <= sec_rollover && min_ones_roll && min_tens_roll;
    end
    
    // Hours and PM logic
    always @(posedge clk) begin
        if (reset) begin
            hour <= 4'd12;
            pm_reg <= 1'b0;
        end else if (min_rollover) begin
            if (hour == 4'd12)
                hour <= 4'd1;
            else
                hour <= hour + 1;
            
            // PM toggles when hour changes from 11 to 12
            if (hour == 4'd11)
                pm_reg <= ~pm_reg;
        end
    end
    
    // BCD conversion for hours (combinational)
    wire [3:0] hr_tens = (hour > 4'd9) ? 4'd1 : 4'd0;
    wire [3:0] hr_ones = (hour > 4'd9) ? hour - 4'd10 : hour;
    
    // Output assignments
    assign pm = pm_reg;
    assign ss = {sec_tens, sec_ones};
    assign mm = {min_tens, min_ones};
    assign hh = {hr_tens, hr_ones};

endmodule