module TopModule (
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

    // State representation
    reg [3:0] seconds_ones;
    reg [2:0] seconds_tens;
    reg [3:0] minutes_ones;
    reg [2:0] minutes_tens;
    reg [3:0] hour;    // 1-12
    reg pm_reg;

    // Continuous output assignments
    assign ss = {seconds_tens, 1'b0, seconds_ones};  // Pack into BCD
    assign mm = {minutes_tens, 1'b0, minutes_ones};  // Pack into BCD
    assign hh = (hour > 9) ? {4'd1, hour - 4'd10} : {4'd0, hour};
    assign pm = pm_reg;

    // Unified state machine
    always @(posedge clk) begin
        if (reset) begin
            // Reset to 12:00:00 AM
            seconds_ones <= 0;
            seconds_tens <= 0;
            minutes_ones <= 0;
            minutes_tens <= 0;
            hour <= 12;
            pm_reg <= 0;
        end
        else if (ena) begin
            // Seconds increment
            if (seconds_ones == 9) begin
                seconds_ones <= 0;
                if (seconds_tens == 5) begin
                    seconds_tens <= 0;
                    
                    // Minutes increment
                    if (minutes_ones == 9) begin
                        minutes_ones <= 0;
                        if (minutes_tens == 5) begin
                            minutes_tens <= 0;
                            
                            // Hours increment
                            if (hour == 12)
                                hour <= 1;
                            else
                                hour <= hour + 1;
                                
                            // PM toggle at 11->12
                            if (hour == 11)
                                pm_reg <= ~pm_reg;
                        end
                        else begin
                            minutes_tens <= minutes_tens + 1;
                        end
                    end
                    else begin
                        minutes_ones <= minutes_ones + 1;
                    end
                end
                else begin
                    seconds_tens <= seconds_tens + 1;
                end
            end
            else begin
                seconds_ones <= seconds_ones + 1;
            end
        end
    end

endmodule