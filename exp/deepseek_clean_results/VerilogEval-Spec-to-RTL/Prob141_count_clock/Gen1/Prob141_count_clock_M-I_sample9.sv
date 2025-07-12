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
    reg [3:0] ss_ones, ss_tens;
    reg [3:0] mm_ones, mm_tens;
    reg [3:0] hh_ones, hh_tens;
    reg sec_rollover, min_rollover;

    // Seconds counter (0-59) with registered rollover
    always @(posedge clk) begin
        if (reset) begin
            ss_ones <= 4'd0;
            ss_tens <= 4'd0;
            sec_rollover <= 1'b0;
        end else if (ena) begin
            sec_rollover <= (ss_tens == 4'd5) && (ss_ones == 4'd9);
            if (ss_ones == 4'd9) begin
                ss_ones <= 4'd0;
                if (ss_tens == 4'd5) begin
                    ss_tens <= 4'd0;
                end else begin
                    ss_tens <= ss_tens + 4'd1;
                end
            end else begin
                ss_ones <= ss_ones + 4'd1;
            end
        end else begin
            sec_rollover <= 1'b0;
        end
    end

    // Minutes counter (0-59) with registered rollover
    always @(posedge clk) begin
        if (reset) begin
            mm_ones <= 4'd0;
            mm_tens <= 4'd0;
            min_rollover <= 1'b0;
        end else if (ena && sec_rollover) begin
            min_rollover <= (mm_tens == 4'd5) && (mm_ones == 4'd9);
            if (mm_ones == 4'd9) begin
                mm_ones <= 4'd0;
                if (mm_tens == 4'd5) begin
                    mm_tens <= 4'd0;
                end else begin
                    mm_tens <= mm_tens + 4'd1;
                end
            end else begin
                mm_ones <= mm_ones + 4'd1;
            end
        end else begin
            min_rollover <= 1'b0;
        end
    end

    // Hours counter (1-12) and PM indicator
    always @(posedge clk) begin
        if (reset) begin
            hh_ones <= 4'd2;
            hh_tens <= 4'd1;
            pm_reg <= 1'b0;
        end else if (ena && min_rollover) begin
            // Handle hour increment
            if (hh_ones == 4'd2 && hh_tens == 4'd1) begin
                // 12 -> 1 transition
                hh_ones <= 4'd1;
                hh_tens <= 4'd0;
            end else if (hh_ones == 4'd9) begin
                hh_ones <= 4'd0;
                hh_tens <= hh_tens + 4'd1;
            end else begin
                hh_ones <= hh_ones + 4'd1;
            end

            // Toggle PM only at 12:59
            if (hh_tens == 4'd1 && hh_ones == 4'd1 && mm_tens == 4'd5 && mm_ones == 4'd9) begin
                pm_reg <= ~pm_reg;
            end
        end
    end

    // Output assignments
    assign pm = pm_reg;
    assign ss = {ss_tens, ss_ones};
    assign mm = {mm_tens, mm_ones};
    assign hh = {hh_tens, hh_ones};

endmodule