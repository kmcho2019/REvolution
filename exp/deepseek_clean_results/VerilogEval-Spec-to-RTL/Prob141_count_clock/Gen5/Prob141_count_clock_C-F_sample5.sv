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
    reg [3:0] hour_ones, hour_tens;
    reg pm_reg;

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

    // Minutes counter (only increments when seconds roll over)
    wire sec_rollover = (sec_ones == 4'd9) && (sec_tens == 4'd5);
    
    always @(posedge clk) begin
        if (reset) begin
            min_ones <= 4'd0;
            min_tens <= 4'd0;
        end else if (ena && sec_rollover) begin
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

    // Hours counter and PM logic (only increments when minutes roll over)
    wire min_rollover = sec_rollover && (min_ones == 4'd9) && (min_tens == 4'd5);
    
    always @(posedge clk) begin
        if (reset) begin
            hour_ones <= 4'd2;
            hour_tens <= 4'd1;
            pm_reg <= 1'b0;
        end else if (ena && min_rollover) begin
            if (hour_ones == 4'd2 && hour_tens == 4'd1) begin
                // 12 -> 01
                hour_ones <= 4'd1;
                hour_tens <= 4'd0;
            end else if (hour_ones == 4'd9) begin
                // 09 -> 10
                hour_ones <= 4'd0;
                hour_tens <= 4'd1;
            end else begin
                hour_ones <= hour_ones + 1;
                // Toggle PM when going from 11 to 12
                if (hour_ones == 4'd1 && hour_tens == 4'd1)
                    pm_reg <= ~pm_reg;
            end
        end
    end

    assign ss = {sec_tens, sec_ones};
    assign mm = {min_tens, min_ones};
    assign hh = {hour_tens, hour_ones};
    assign pm = pm_reg;

endmodule