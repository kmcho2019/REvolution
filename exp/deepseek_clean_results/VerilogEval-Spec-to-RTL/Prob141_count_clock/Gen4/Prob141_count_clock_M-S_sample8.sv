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
    reg [3:0] ss_lo;  // seconds low digit (0-9)
    reg [2:0] ss_hi;  // seconds high digit (0-5)
    reg [3:0] mm_lo;  // minutes low digit (0-9)
    reg [2:0] mm_hi;  // minutes high digit (0-5)
    reg [4:0] hour;   // hours (1-12)

    // Seconds counter
    always @(posedge clk) begin
        if (reset) begin
            {ss_hi, ss_lo} <= 0;
        end else if (ena) begin
            if (ss_lo == 9) begin
                ss_lo <= 0;
                ss_hi <= (ss_hi == 5) ? 0 : ss_hi + 1;
            end else begin
                ss_lo <= ss_lo + 1;
            end
        end
    end

    // Minutes counter
    always @(posedge clk) begin
        if (reset) begin
            {mm_hi, mm_lo} <= 0;
        end else if (ena && ss_lo == 9 && ss_hi == 5) begin
            if (mm_lo == 9) begin
                mm_lo <= 0;
                mm_hi <= (mm_hi == 5) ? 0 : mm_hi + 1;
            end else begin
                mm_lo <= mm_lo + 1;
            end
        end
    end

    // Hours and PM counter
    always @(posedge clk) begin
        if (reset) begin
            hour <= 12;
            pm_reg <= 0;
        end else if (ena && ss_lo == 9 && ss_hi == 5 && mm_lo == 9 && mm_hi == 5) begin
            if (hour == 12) begin
                hour <= 1;
            end else begin
                hour <= hour + 1;
                if (hour == 11) pm_reg <= ~pm_reg;
            end
        end
    end

    // Output assignments (convert hour to BCD)
    assign pm = pm_reg;
    assign ss = {1'b0, ss_hi, ss_lo};
    assign mm = {1'b0, mm_hi, mm_lo};
    assign hh = (hour < 10) ? {4'b0, hour[3:0]} : {4'b0001, hour[3:0] - 4'd10};

endmodule