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
    reg [3:0] ss_lo;      // seconds low digit (0-9)
    reg [2:0] ss_hi;      // seconds high digit (0-5)
    reg [3:0] mm_lo;      // minutes low digit (0-9)
    reg [2:0] mm_hi;      // minutes high digit (0-5)
    reg [3:0] hour;       // hours (1-12)
    reg sec_roll, min_roll; // registered rollover signals
    
    // Registered BCD outputs
    reg [7:0] hh_reg, mm_reg, ss_reg;
    
    // Seconds counter with registered rollover
    always @(posedge clk) begin
        if (reset) begin
            {ss_hi, ss_lo} <= 0;
            sec_roll <= 0;
        end else if (ena) begin
            sec_roll <= 0;
            if (ss_lo == 9) begin
                ss_lo <= 0;
                if (ss_hi == 5) begin
                    ss_hi <= 0;
                    sec_roll <= 1;
                end else begin
                    ss_hi <= ss_hi + 1;
                end
            end else begin
                ss_lo <= ss_lo + 1;
            end
        end
    end

    // Minutes counter with registered rollover
    always @(posedge clk) begin
        if (reset) begin
            {mm_hi, mm_lo} <= 0;
            min_roll <= 0;
        end else if (ena && sec_roll) begin
            min_roll <= 0;
            if (mm_lo == 9) begin
                mm_lo <= 0;
                if (mm_hi == 5) begin
                    mm_hi <= 0;
                    min_roll <= 1;
                end else begin
                    mm_hi <= mm_hi + 1;
                end
            end else begin
                mm_lo <= mm_lo + 1;
            end
        end
    end

    // Hours counter with clock gated PM indicator
    wire hour_inc = ena && sec_roll && min_roll;
    wire pm_toggle = (hour == 11);
    
    always @(posedge clk) begin
        if (reset) begin
            hour <= 4'd12;
        end else if (hour_inc) begin
            hour <= (hour == 12) ? 4'd1 : hour + 1;
        end
    end
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            pm_reg <= 0;
        end else if (hour_inc && pm_toggle) begin
            pm_reg <= ~pm_reg;
        end
    end

    // Output assignments (pre-computed BCD)
    always @(posedge clk) begin
        if (reset) begin
            ss_reg <= 8'h00;
            mm_reg <= 8'h00;
            hh_reg <= 8'h12;
        end else begin
            ss_reg <= {1'b0, ss_hi, ss_lo};
            mm_reg <= {1'b0, mm_hi, mm_lo};
            
            // Direct BCD mapping for hours (1-12)
            case (hour)
                4'd1:  hh_reg <= 8'h01;
                4'd2:  hh_reg <= 8'h02;
                4'd3:  hh_reg <= 8'h03;
                4'd4:  hh_reg <= 8'h04;
                4'd5:  hh_reg <= 8'h05;
                4'd6:  hh_reg <= 8'h06;
                4'd7:  hh_reg <= 8'h07;
                4'd8:  hh_reg <= 8'h08;
                4'd9:  hh_reg <= 8'h09;
                4'd10: hh_reg <= 8'h10;
                4'd11: hh_reg <= 8'h11;
                4'd12: hh_reg <= 8'h12;
                default: hh_reg <= 8'h12;
            endcase
        end
    end

    assign pm = pm_reg;
    assign hh = hh_reg;
    assign mm = mm_reg;
    assign ss = ss_reg;

endmodule