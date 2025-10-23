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
    reg [3:0] hour_tens;  // 0 or 1 (for 12-hour format)
    reg [3:0] hour_ones;  // 0-9
    reg [3:0] min_tens;   // 0-5
    reg [3:0] min_ones;   // 0-9
    reg [3:0] sec_tens;   // 0-5
    reg [3:0] sec_ones;   // 0-9

    // Rollover detection
    wire sec_inc = ena;
    wire sec_roll = (sec_ones == 4'd9) && (sec_tens == 4'd5) && sec_inc;
    wire min_inc = sec_roll;
    wire min_roll = (min_ones == 4'd9) && (min_tens == 4'd5) && min_inc;
    wire hour_inc = min_roll;
    wire hour_roll = (hour_ones == 4'd2) && (hour_tens == 4'd1) && hour_inc;

    // Seconds counter
    always @(posedge clk) begin
        if (reset) begin
            sec_tens <= 4'd0;
            sec_ones <= 4'd0;
        end else if (sec_inc) begin
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

    // Minutes counter
    always @(posedge clk) begin
        if (reset) begin
            min_tens <= 4'd0;
            min_ones <= 4'd0;
        end else if (min_inc) begin
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

    // Hours and PM logic
    always @(posedge clk) begin
        if (reset) begin
            hour_tens <= 4'd1;
            hour_ones <= 4'd2;
            pm_reg <= 1'b0;
        end else if (hour_inc) begin
            if (hour_ones == 4'd2 && hour_tens == 4'd1) begin
                hour_ones <= 4'd1;
                hour_tens <= 4'd0;
            end else if (hour_ones == 4'd9) begin
                hour_ones <= 4'd0;
                hour_tens <= hour_tens + 1;
            end else begin
                hour_ones <= hour_ones + 1;
            end
            
            // Toggle PM when going from 11 to 12
            if (hour_ones == 4'd1 && hour_tens == 4'd1)
                pm_reg <= ~pm_reg;
        end
    end

    // Output assignments
    assign ss = {sec_tens, sec_ones};
    assign mm = {min_tens, min_ones};
    assign hh = {hour_tens, hour_ones};
    assign pm = pm_reg;

endmodule