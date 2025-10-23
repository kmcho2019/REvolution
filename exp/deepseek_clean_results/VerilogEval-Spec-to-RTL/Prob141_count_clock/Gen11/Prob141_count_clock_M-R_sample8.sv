module TopModule (
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

    // BCD counters (registered outputs)
    reg [3:0] sec_ones, sec_tens;
    reg [3:0] min_ones, min_tens;
    reg [3:0] hr_ones, hr_tens;
    
    // Internal hour counter (1-12)
    reg [4:0] hour_cnt;
    
    // State machine for time increments
    always @(posedge clk) begin
        if (reset) begin
            // Reset to 12:00:00 AM
            sec_ones <= 4'd0;
            sec_tens <= 4'd0;
            min_ones <= 4'd0;
            min_tens <= 4'd0;
            hr_ones <= 4'd2;
            hr_tens <= 4'd1;
            hour_cnt <= 5'd12;
        end
        else if (ena) begin
            // Seconds increment
            if (sec_ones == 4'd9) begin
                sec_ones <= 4'd0;
                if (sec_tens == 4'd5) begin
                    sec_tens <= 4'd0;
                    
                    // Minutes increment
                    if (min_ones == 4'd9) begin
                        min_ones <= 4'd0;
                        if (min_tens == 4'd5) begin
                            min_tens <= 4'd0;
                            
                            // Hours increment
                            hour_cnt <= (hour_cnt == 5'd12) ? 5'd1 : hour_cnt + 1;
                            
                            // Convert hour to BCD
                            if (hour_cnt == 5'd9) begin
                                hr_ones <= 4'd0;
                                hr_tens <= 4'd1;
                            end
                            else if (hour_cnt == 5'd12) begin
                                hr_ones <= 4'd2;
                                hr_tens <= 4'd1;
                            end
                            else if (hour_cnt >= 5'd10) begin
                                hr_ones <= hour_cnt[3:0] - 4'd10;
                                hr_tens <= 4'd1;
                            end
                            else begin
                                hr_ones <= hour_cnt[3:0];
                                hr_tens <= 4'd0;
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

    // PM is high when hour is 12-11 (12:00:00 to 11:59:59 counts as PM)
    assign pm = (hour_cnt >= 5'd12) || (hour_cnt < 5'd1) ? 1'b1 : 
                (hour_cnt >= 5'd1 && hour_cnt < 5'd12) ? 1'b0 : 1'b0;
    
    // Output assignments
    assign ss = {sec_tens, sec_ones};
    assign mm = {min_tens, min_ones};
    assign hh = {hr_tens, hr_ones};

endmodule