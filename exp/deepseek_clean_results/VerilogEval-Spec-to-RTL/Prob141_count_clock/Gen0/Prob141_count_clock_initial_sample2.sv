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
    reg [3:0] hr_ones, hr_tens;
    reg pm_reg;

    // Combine BCD digits for outputs
    assign ss = {sec_tens, sec_ones};
    assign mm = {min_tens, min_ones};
    assign hh = {hr_tens, hr_ones};
    assign pm = pm_reg;

    always @(posedge clk) begin
        if (reset) begin
            // Reset to 12:00:00 AM
            sec_ones <= 4'd0;
            sec_tens <= 4'd0;
            min_ones <= 4'd0;
            min_tens <= 4'd0;
            hr_ones <= 4'd2;
            hr_tens <= 4'd1;
            pm_reg <= 1'b0;
        end
        else if (ena) begin
            // Seconds counter
            if (sec_ones == 4'd9) begin
                sec_ones <= 4'd0;
                if (sec_tens == 4'd5) begin
                    sec_tens <= 4'd0;
                    
                    // Minutes counter
                    if (min_ones == 4'd9) begin
                        min_ones <= 4'd0;
                        if (min_tens == 4'd5) begin
                            min_tens <= 4'd0;
                            
                            // Hours counter
                            if (hr_ones == 4'd2 && hr_tens == 4'd1) begin
                                // 12 -> 1
                                hr_ones <= 4'd1;
                                hr_tens <= 4'd0;
                                pm_reg <= ~pm_reg;
                            end
                            else if (hr_ones == 4'd9) begin
                                hr_ones <= 4'd0;
                                hr_tens <= hr_tens + 1;
                            end
                            else begin
                                hr_ones <= hr_ones + 1;
                                if (hr_ones == 4'd1 && hr_tens == 4'd0) begin
                                    // 9 -> 10
                                    hr_ones <= 4'd0;
                                    hr_tens <= 4'd1;
                                end
                            end
                        end
                        else begin
                            min_tens <= min_tens + 1;
                        end
                    end
                    else begin
                        min_ones <= min_ones + 1;
                    end
                end
                else begin
                    sec_tens <= sec_tens + 1;
                end
            end
            else begin
                sec_ones <= sec_ones + 1;
            end
        end
    end

endmodule