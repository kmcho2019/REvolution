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
    reg [3:0] ss_lo;  // seconds ones (0-9)
    reg [2:0] ss_hi;  // seconds tens (0-5)
    reg [3:0] mm_lo;  // minutes ones (0-9)
    reg [2:0] mm_hi;  // minutes tens (0-5)
    reg [3:0] hour;   // hours (1-12)

    // Rollover flags (parallel detection)
    wire ss_roll = (ss_hi == 3'd5) && (ss_lo == 4'd9) && ena;
    wire mm_roll = (mm_hi == 3'd5) && (mm_lo == 4'd9) && ss_roll;

    // Pre-computed BCD hour digits
    wire [3:0] hr_tens = (hour > 9) ? 4'd1 : 4'd0;
    wire [3:0] hr_ones = (hour > 9) ? hour - 4'd10 : hour;
    assign hh = {hr_tens, hr_ones};

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
        end else if (ss_roll) begin
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
            hour <= 4'd12;
            pm_reg <= 0;
        end else if (mm_roll) begin
            if (hour == 12) begin
                hour <= 1;
            end else begin
                hour <= hour + 1;
                if (hour == 11) pm_reg <= ~pm_reg;
            end
        end
    end

    // Output assignments
    assign pm = pm_reg;
    assign ss = {1'b0, ss_hi, ss_lo};
    assign mm = {1'b0, mm_hi, mm_lo};

endmodule