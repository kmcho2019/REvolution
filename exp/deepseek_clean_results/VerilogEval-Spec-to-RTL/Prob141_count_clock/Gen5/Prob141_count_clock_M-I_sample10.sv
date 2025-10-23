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
    reg sec_rollover_reg, min_rollover_reg;
    
    // Combinational rollover conditions
    wire sec_ones_max = (sec_ones == 4'd9);
    wire sec_tens_max = (sec_tens == 4'd5);
    wire min_ones_max = (min_ones == 4'd9);
    wire min_tens_max = (min_tens == 4'd5);
    
    // Registered rollover signals (updated only when enabled)
    always @(posedge clk) begin
        if (reset) begin
            sec_rollover_reg <= 1'b0;
            min_rollover_reg <= 1'b0;
        end else if (ena) begin
            sec_rollover_reg <= sec_ones_max && sec_tens_max;
            min_rollover_reg <= sec_rollover_reg && min_ones_max && min_tens_max;
        end else begin
            sec_rollover_reg <= 1'b0;
            min_rollover_reg <= 1'b0;
        end
    end

    // Seconds counter (00-59)
    always @(posedge clk) begin
        if (reset) begin
            sec_ones <= 4'd0;
            sec_tens <= 4'd0;
        end else if (ena) begin
            if (sec_ones_max) begin
                sec_ones <= 4'd0;
                if (sec_tens_max)
                    sec_tens <= 4'd0;
                else
                    sec_tens <= sec_tens + 1;
            end else begin
                sec_ones <= sec_ones + 1;
            end
        end
    end

    // Minutes counter (00-59)
    always @(posedge clk) begin
        if (reset) begin
            min_ones <= 4'd0;
            min_tens <= 4'd0;
        end else if (ena && sec_rollover_reg) begin
            if (min_ones_max) begin
                min_ones <= 4'd0;
                if (min_tens_max)
                    min_tens <= 4'd0;
                else
                    min_tens <= min_tens + 1;
            end else begin
                min_ones <= min_ones + 1;
            end
        end
    end

    // Hours counter (1-12) with efficient encoding
    always @(posedge clk) begin
        if (reset) begin
            hour <= 4'd12;
        end else if (ena && min_rollover_reg) begin
            if (hour == 4'd12)
                hour <= 4'd1;
            else
                hour <= hour + 1;
        end
    end

    // PM indicator (only updates at 11->12 transition)
    always @(posedge clk) begin
        if (reset) begin
            pm_reg <= 1'b0;
        end else if (ena && min_rollover_reg && hour == 4'd11) begin
            pm_reg <= ~pm_reg;
        end
    end

    // Gated BCD conversion for hours (only updates when hour changes)
    reg [3:0] hr_tens, hr_ones;
    always @(posedge clk) begin
        if (reset) begin
            hr_tens <= 4'd1;
            hr_ones <= 4'd2;
        end else if (ena && (min_rollover_reg || reset)) begin
            hr_tens <= (hour > 4'd9) ? 4'd1 : 4'd0;
            hr_ones <= (hour > 4'd9) ? hour - 4'd10 : hour;
        end
    end

    // Output assignments
    assign pm = pm_reg;
    assign ss = {sec_tens, sec_ones};
    assign mm = {min_tens, min_ones};
    assign hh = {hr_tens, hr_ones};

endmodule