module TopModule (
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

    // Direct BCD counters
    reg [3:0] sec_ones, sec_tens;
    reg [3:0] min_ones, min_tens;
    reg [3:0] hr_tens, hr_ones;  // BCD hours (01-12)
    reg pm_reg;

    // Registered enable signals
    reg sec_inc_reg, min_inc_reg, hour_inc_reg;

    always @(posedge clk) begin
        sec_inc_reg <= ena;
        min_inc_reg <= sec_inc_reg && (sec_ones == 4'd9) && (sec_tens == 4'd5);
        hour_inc_reg <= min_inc_reg && (min_ones == 4'd9) && (min_tens == 4'd5);
    end

    // Seconds counter (00-59 BCD)
    always @(posedge clk) begin
        if (reset) begin
            sec_ones <= 4'd0;
            sec_tens <= 4'd0;
        end else if (sec_inc_reg) begin
            if (sec_ones == 4'd9) begin
                sec_ones <= 4'd0;
                sec_tens <= (sec_tens == 4'd5) ? 4'd0 : sec_tens + 1;
            end else begin
                sec_ones <= sec_ones + 1;
            end
        end
    end

    // Minutes counter (00-59 BCD)
    always @(posedge clk) begin
        if (reset) begin
            min_ones <= 4'd0;
            min_tens <= 4'd0;
        end else if (min_inc_reg) begin
            if (min_ones == 4'd9) begin
                min_ones <= 4'd0;
                min_tens <= (min_tens == 4'd5) ? 4'd0 : min_tens + 1;
            end else begin
                min_ones <= min_ones + 1;
            end
        end
    end

    // Hours counter (01-12 BCD) with PM indicator
    always @(posedge clk) begin
        if (reset) begin
            hr_tens <= 4'd1;
            hr_ones <= 4'd2;
            pm_reg <= 1'b0;
        end else if (hour_inc_reg) begin
            // Handle hour rollover with BCD arithmetic
            if (hr_ones == 4'd2 && hr_tens == 4'd1) begin  // 12 -> 01
                hr_tens <= 4'd0;
                hr_ones <= 4'd1;
                pm_reg <= ~pm_reg;
            end else if (hr_ones == 4'd9) begin
                hr_ones <= 4'd0;
                hr_tens <= hr_tens + 1;
            end else begin
                hr_ones <= hr_ones + 1;
            end
        end
    end

    // Output assignments
    assign ss = {sec_tens, sec_ones};
    assign mm = {min_tens, min_ones};
    assign hh = {hr_tens, hr_ones};
    assign pm = pm_reg;

endmodule