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
    reg [3:0] hour;   // hours (1-12)
    
    // Registered signals for rollover conditions
    reg sec_roll, min_roll;

    // Seconds counter
    always @(posedge clk) begin
        if (reset) begin
            ss_lo <= 0;
            ss_hi <= 0;
            sec_roll <= 0;
        end else if (ena) begin
            sec_roll <= (ss_lo == 9) && (ss_hi == 5);
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
            mm_lo <= 0;
            mm_hi <= 0;
            min_roll <= 0;
        end else if (ena && sec_roll) begin
            min_roll <= (mm_lo == 9) && (mm_hi == 5);
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
        end else if (ena && sec_roll && min_roll) begin
            if (hour == 12) begin
                hour <= 1;
            end else begin
                hour <= hour + 1;
            end
            
            // Toggle PM when hour changes from 11 to 12
            if (hour == 11) pm_reg <= ~pm_reg;
        end
    end

    // BCD output generation (pre-computed in registers)
    reg [7:0] hh_reg, mm_reg, ss_reg;
    always @(posedge clk) begin
        if (reset) begin
            hh_reg <= 8'h12;
            mm_reg <= 0;
            ss_reg <= 0;
        end else begin
            // Seconds BCD
            ss_reg <= {1'b0, ss_hi, ss_lo};
            
            // Minutes BCD
            mm_reg <= {1'b0, mm_hi, mm_lo};
            
            // Hours BCD
            hh_reg <= (hour < 10) ? {4'b0, hour} : {4'b0001, hour - 4'd10};
        end
    end

    assign pm = pm_reg;
    assign hh = hh_reg;
    assign mm = mm_reg;
    assign ss = ss_reg;

endmodule