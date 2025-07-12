module TopModule (
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

    // Constants for counter limits
    localparam SEC_LO_MAX = 4'd9;
    localparam SEC_HI_MAX = 3'd5;
    localparam MIN_LO_MAX = 4'd9;
    localparam MIN_HI_MAX = 3'd5;
    localparam HOUR_MAX   = 4'd12;
    localparam HOUR_MIN   = 4'd1;

    reg pm_reg;
    reg [3:0] ss_lo;  // seconds low digit (0-9)
    reg [2:0] ss_hi;  // seconds high digit (0-5)
    reg [3:0] mm_lo;  // minutes low digit (0-9)
    reg [2:0] mm_hi;  // minutes high digit (0-5)
    reg [3:0] hh_lo;  // hours low digit (0-9)
    reg [0:0] hh_hi;  // hours high digit (0-1)

    wire sec_tick = (ss_lo == SEC_LO_MAX);
    wire min_tick = (ss_hi == SEC_HI_MAX) & sec_tick;
    wire hour_tick = (mm_hi == MIN_HI_MAX) & (mm_lo == MIN_LO_MAX) & min_tick;

    always @(posedge clk) begin
        if (reset) begin
            // Reset to 12:00:00 AM
            ss_lo <= 0;
            ss_hi <= 0;
            mm_lo <= 0;
            mm_hi <= 0;
            hh_lo <= 2;
            hh_hi <= 1;
            pm_reg <= 0;
        end else if (ena) begin
            // Seconds counter
            if (sec_tick) begin
                ss_lo <= 0;
                if (ss_hi == SEC_HI_MAX)
                    ss_hi <= 0;
                else
                    ss_hi <= ss_hi + 1;
            end else begin
                ss_lo <= ss_lo + 1;
            end

            // Minutes counter
            if (min_tick) begin
                if (mm_lo == MIN_LO_MAX) begin
                    mm_lo <= 0;
                    if (mm_hi == MIN_HI_MAX)
                        mm_hi <= 0;
                    else
                        mm_hi <= mm_hi + 1;
                end else begin
                    mm_lo <= mm_lo + 1;
                end
            end

            // Hours and PM counter
            if (hour_tick) begin
                if ({hh_hi, hh_lo} == 4'd12) begin
                    hh_lo <= 1;
                    hh_hi <= 0;
                    pm_reg <= ~pm_reg;
                end else if (hh_lo == 4'd9) begin
                    hh_lo <= 0;
                    hh_hi <= hh_hi + 1;
                end else begin
                    hh_lo <= hh_lo + 1;
                end
            end
        end
    end

    // Output assignments
    assign pm = pm_reg;
    assign ss = {1'b0, ss_hi, ss_lo};
    assign mm = {1'b0, mm_hi, mm_lo};
    assign hh = {3'b0, hh_hi, hh_lo};

endmodule