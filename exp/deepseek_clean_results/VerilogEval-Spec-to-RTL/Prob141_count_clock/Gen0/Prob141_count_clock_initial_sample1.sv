module TopModule (
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

    reg [3:0] sec_ones;
    reg [3:0] sec_tens;
    reg [3:0] min_ones;
    reg [3:0] min_tens;
    reg [3:0] hour_ones;
    reg [3:0] hour_tens;
    reg pm_reg;

    // Assign outputs
    assign ss = {sec_tens, sec_ones};
    assign mm = {min_tens, min_ones};
    assign hh = {hour_tens, hour_ones};
    assign pm = pm_reg;

    always @(posedge clk) begin
        if (reset) begin
            // Reset to 12:00:00 AM
            sec_ones <= 4'd0;
            sec_tens <= 4'd0;
            min_ones <= 4'd0;
            min_tens <= 4'd0;
            hour_ones <= 4'd2;
            hour_tens <= 4'd1;
            pm_reg <= 1'b0;
        end else if (ena) begin
            // Seconds counter
            if (sec_ones == 4'd9) begin
                sec_ones <= 4'd0;
                if (sec_tens == 4'd5) begin
                    sec_tens <= 4'd0;
                    // Minute increment
                    if (min_ones == 4'd9) begin
                        min_ones <= 4'd0;
                        if (min_tens == 4'd5) begin
                            min_tens <= 4'd0;
                            // Hour increment
                            if (hour_ones == 4'd2 && hour_tens == 4'd1) begin
                                // 12 -> 1
                                hour_ones <= 4'd1;
                                hour_tens <= 4'd0;
                            end else if (hour_ones == 4'd9) begin
                                hour_ones <= 4'd0;
                                hour_tens <= hour_tens + 1;
                            end else begin
                                hour_ones <= hour_ones + 1;
                            end
                            
                            // Toggle AM/PM at 12:00
                            if (hour_ones == 4'd1 && hour_tens == 4'd1) begin
                                pm_reg <= ~pm_reg;
                            end
                        end else begin
                            min_tens <= min_tens + 1;
                        end
                    end else begin
                        min_ones <= min_ones + 1;
                    end
                end else begin
                    sec_tens <= sec_tens + 1;
                end
            end else begin
                sec_ones <= sec_ones + 1;
            end
        end
    end

endmodule