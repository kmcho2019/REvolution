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
    reg [3:0] ss_lo, ss_hi;  // seconds digits
    reg [3:0] mm_lo, mm_hi;  // minutes digits
    reg [3:0] hh_lo, hh_hi;  // hours digits

    // Seconds counter
    always @(posedge clk) begin
        if (reset) begin
            {ss_hi, ss_lo} <= 8'h00;
        end
        else if (ena) begin
            if (ss_lo == 4'd9) begin
                ss_lo <= 0;
                ss_hi <= (ss_hi == 4'd5) ? 0 : ss_hi + 1;
            end
            else begin
                ss_lo <= ss_lo + 1;
            end
        end
    end

    // Minutes counter (triggered by seconds rollover)
    wire min_inc = ena & (ss_hi == 4'd5) & (ss_lo == 4'd9);
    always @(posedge clk) begin
        if (reset) begin
            {mm_hi, mm_lo} <= 8'h00;
        end
        else if (min_inc) begin
            if (mm_lo == 4'd9) begin
                mm_lo <= 0;
                mm_hi <= (mm_hi == 4'd5) ? 0 : mm_hi + 1;
            end
            else begin
                mm_lo <= mm_lo + 1;
            end
        end
    end

    // Hours counter (triggered by minutes rollover)
    wire hour_inc = min_inc & (mm_hi == 4'd5) & (mm_lo == 4'd9);
    always @(posedge clk) begin
        if (reset) begin
            {hh_hi, hh_lo} <= 8'h12;
        end
        else if (hour_inc) begin
            if ({hh_hi, hh_lo} == 8'h12) begin
                {hh_hi, hh_lo} <= 8'h01;
            end
            else if (hh_lo == 4'd9) begin
                {hh_hi, hh_lo} <= {hh_hi + 1, 4'd0};
            end
            else begin
                hh_lo <= hh_lo + 1;
            end
        end
    end

    // PM indicator (toggles at 11->12 transition)
    always @(posedge clk) begin
        if (reset) begin
            pm_reg <= 0;
        end
        else if (hour_inc && ({hh_hi, hh_lo} == 8'h11)) begin
            pm_reg <= ~pm_reg;
        end
    end

    // Direct output assignments
    assign pm = pm_reg;
    assign ss = {ss_hi, ss_lo};
    assign mm = {mm_hi, mm_lo};
    assign hh = {hh_hi, hh_lo};

endmodule