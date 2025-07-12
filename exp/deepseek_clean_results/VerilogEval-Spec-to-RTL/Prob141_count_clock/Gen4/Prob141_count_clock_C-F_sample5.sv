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
    reg [3:0] hour;  // 1-12 counter
    reg pm_reg;
    wire sec_rollover, min_rollover;

    // Gated rollover signals
    assign sec_rollover = (sec_ones == 4'd9) && (sec_tens == 4'd5);
    assign min_rollover = sec_rollover && (min_ones == 4'd9) && (min_tens == 4'd5);

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

    // Minutes counter
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

    // Hours counter and PM logic
    always @(posedge clk) begin
        if (reset) begin
            hour <= 4'd12;
            pm_reg <= 1'b0;
        end else if (ena && min_rollover) begin
            if (hour == 4'd12)
                hour <= 4'd1;
            else
                hour <= hour + 1;
            
            // Toggle PM when hour changes from 11 to 12
            if (hour == 4'd11)
                pm_reg <= ~pm_reg;
        end
    end

    // BCD conversion for hours
    wire [3:0] hr_tens = (hour > 4'd9) ? 4'd1 : 4'd0;
    wire [3:0] hr_ones = (hour > 4'd9) ? hour - 4'd10 : hour;

    assign ss = {sec_tens, sec_ones};
    assign mm = {min_tens, min_ones};
    assign hh = {hr_tens, hr_ones};
    assign pm = pm_reg;

endmodule