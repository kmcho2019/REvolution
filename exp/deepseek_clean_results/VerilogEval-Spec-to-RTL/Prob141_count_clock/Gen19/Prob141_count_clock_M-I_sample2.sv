module TopModule (
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

    // Packed BCD registers with registered rollover signals
    reg [7:0] ss_reg;  // seconds (00-59)
    reg [7:0] mm_reg;  // minutes (00-59)
    reg [7:0] hh_reg;  // hours (01-12 in BCD)
    reg pm_reg;

    // Registered rollover signals
    reg sec_rollover;
    reg min_rollover;
    reg hour_inc;

    // Continuous outputs
    assign pm = pm_reg;
    assign ss = ss_reg;
    assign mm = mm_reg;
    assign hh = hh_reg;

    // Seconds counter (00-59)
    always @(posedge clk) begin
        if (reset) begin
            ss_reg <= 8'h00;
            sec_rollover <= 1'b0;
        end
        else if (ena) begin
            if (ss_reg[3:0] == 4'd9) begin
                ss_reg[3:0] <= 4'd0;
                if (ss_reg[7:4] == 4'd5) begin
                    ss_reg[7:4] <= 4'd0;
                    sec_rollover <= 1'b1;
                end
                else begin
                    ss_reg[7:4] <= ss_reg[7:4] + 1;
                    sec_rollover <= 1'b0;
                end
            end
            else begin
                ss_reg[3:0] <= ss_reg[3:0] + 1;
                sec_rollover <= 1'b0;
            end
        end
        else begin
            sec_rollover <= 1'b0;
        end
    end

    // Minutes counter (00-59)
    always @(posedge clk) begin
        if (reset) begin
            mm_reg <= 8'h00;
            min_rollover <= 1'b0;
        end
        else if (ena && sec_rollover) begin
            if (mm_reg[3:0] == 4'd9) begin
                mm_reg[3:0] <= 4'd0;
                if (mm_reg[7:4] == 4'd5) begin
                    mm_reg[7:4] <= 4'd0;
                    min_rollover <= 1'b1;
                end
                else begin
                    mm_reg[7:4] <= mm_reg[7:4] + 1;
                    min_rollover <= 1'b0;
                end
            end
            else begin
                mm_reg[3:0] <= mm_reg[3:0] + 1;
                min_rollover <= 1'b0;
            end
        end
        else begin
            min_rollover <= 1'b0;
        end
    end

    // Hours counter (01-12) and PM indicator
    always @(posedge clk) begin
        if (reset) begin
            hh_reg <= 8'h12;  // BCD 12
            pm_reg <= 1'b0;
            hour_inc <= 1'b0;
        end
        else begin
            hour_inc <= ena && min_rollover;
            
            if (hour_inc) begin
                if (hh_reg == 8'h11) begin  // BCD 11
                    hh_reg <= 8'h12;        // BCD 12
                    pm_reg <= ~pm_reg;
                end
                else if (hh_reg == 8'h12) begin
                    hh_reg <= 8'h01;        // BCD 01
                end
                else if (hh_reg[3:0] == 4'd9) begin
                    hh_reg[3:0] <= 4'd0;
                    hh_reg[7:4] <= hh_reg[7:4] + 1;
                end
                else begin
                    hh_reg[3:0] <= hh_reg[3:0] + 1;
                end
            end
        end
    end

endmodule