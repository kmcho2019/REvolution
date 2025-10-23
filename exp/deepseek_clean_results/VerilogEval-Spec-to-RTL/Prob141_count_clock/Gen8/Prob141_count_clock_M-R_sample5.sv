module TopModule (
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

    // Current state registers
    reg [3:0] ss_lo, ss_hi;  // seconds: ss_hi (0-5), ss_lo (0-9)
    reg [3:0] mm_lo, mm_hi;  // minutes: mm_hi (0-5), mm_lo (0-9)
    reg [3:0] hour;          // hours (1-12)
    reg pm_reg;

    // Next state wires
    wire [3:0] next_ss_lo, next_ss_hi;
    wire [3:0] next_mm_lo, next_mm_hi;
    wire [3:0] next_hour;
    wire next_pm;

    // Seconds counter logic
    assign next_ss_lo = reset ? 4'b0 : (ena ? (ss_lo == 9 ? 4'b0 : ss_lo + 1) : ss_lo;
    assign next_ss_hi = reset ? 4'b0 : (ena && ss_lo == 9 ? (ss_hi == 5 ? 4'b0 : ss_hi + 1) : ss_hi);

    // Minutes counter logic
    assign next_mm_lo = reset ? 4'b0 : (ena && ss_lo == 9 && ss_hi == 5 ? 
                         (mm_lo == 9 ? 4'b0 : mm_lo + 1) : mm_lo);
    assign next_mm_hi = reset ? 4'b0 : (ena && ss_lo == 9 && ss_hi == 5 && mm_lo == 9 ? 
                         (mm_hi == 5 ? 4'b0 : mm_hi + 1) : mm_hi);

    // Hours and PM logic
    wire hour_rollover = ena && ss_lo == 9 && ss_hi == 5 && mm_lo == 9 && mm_hi == 5;
    assign next_hour = reset ? 4'd12 : 
                      (hour_rollover ? (hour == 12 ? 4'd1 : hour + 1) : hour);
    assign next_pm = reset ? 1'b0 : 
                    (hour_rollover && hour == 11 ? ~pm_reg : pm_reg);

    // Register updates
    always @(posedge clk) begin
        ss_lo <= next_ss_lo;
        ss_hi <= next_ss_hi;
        mm_lo <= next_mm_lo;
        mm_hi <= next_mm_hi;
        hour <= next_hour;
        pm_reg <= next_pm;
    end

    // Pre-computed BCD outputs
    wire [7:0] hh_bcd = (hour < 10) ? {4'b0, hour} : {4'b0001, hour - 4'd10};
    wire [7:0] mm_bcd = {1'b0, mm_hi[2:0], mm_lo};
    wire [7:0] ss_bcd = {1'b0, ss_hi[2:0], ss_lo};

    // Registered outputs
    reg [7:0] hh_reg, mm_reg, ss_reg;
    reg pm_out;
    
    always @(posedge clk) begin
        hh_reg <= hh_bcd;
        mm_reg <= mm_bcd;
        ss_reg <= ss_bcd;
        pm_out <= pm_reg;
    end

    assign pm = pm_out;
    assign hh = hh_reg;
    assign mm = mm_reg;
    assign ss = ss_reg;

endmodule