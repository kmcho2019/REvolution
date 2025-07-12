module TopModule (
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

    // Counter registers (BCD encoded)
    reg [3:0] sec_ones, sec_tens;
    reg [3:0] min_ones, min_tens;
    reg [3:0] hour_ones;
    reg hour_tens;
    reg pm_reg;

    // Seconds counter (00-59)
    always @(posedge clk) begin
        if (reset) begin
            sec_ones <= 0;
            sec_tens <= 0;
        end else if (ena) begin
            if (sec_ones == 9) begin
                sec_ones <= 0;
                sec_tens <= (sec_tens == 5) ? 0 : sec_tens + 1;
            end else begin
                sec_ones <= sec_ones + 1;
            end
        end
    end

    // Minutes counter (00-59)
    always @(posedge clk) begin
        if (reset) begin
            min_ones <= 0;
            min_tens <= 0;
        end else if (ena && sec_ones == 9 && sec_tens == 5) begin
            if (min_ones == 9) begin
                min_ones <= 0;
                min_tens <= (min_tens == 5) ? 0 : min_tens + 1;
            end else begin
                min_ones <= min_ones + 1;
            end
        end
    end

    // Hours counter (1-12) and PM indicator
    always @(posedge clk) begin
        if (reset) begin
            hour_ones <= 2;
            hour_tens <= 1;
            pm_reg <= 0;
        end else if (ena && sec_ones == 9 && sec_tens == 5 && 
                   min_ones == 9 && min_tens == 5) begin
            if (hour_ones == 2 && hour_tens == 1) begin
                hour_ones <= 1;
                hour_tens <= 0;
                pm_reg <= ~pm_reg;
            end else if (hour_ones == 9) begin
                hour_ones <= 0;
                hour_tens <= 1;
            end else begin
                hour_ones <= hour_ones + 1;
            end
        end
    end

    // Output assignments
    assign pm = pm_reg;
    assign ss = {sec_tens, sec_ones};
    assign mm = {min_tens, min_ones};
    assign hh = {hour_tens, hour_ones};

endmodule