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
    reg [7:0] ss_reg;  // seconds in BCD (00-59)
    reg [7:0] mm_reg;  // minutes in BCD (00-59)
    reg [7:0] hh_reg;  // hours in BCD (01-12)
    
    // Rollover signals
    wire ss_rollover = (ss_reg == 8'h59);
    wire mm_rollover = (mm_reg == 8'h59);
    wire hh_rollover = (hh_reg == 8'h11); // 11 AM/PM
    
    // Enable signals
    wire ss_en = ena;
    wire mm_en = ena && ss_rollover;
    wire hh_en = ena && ss_rollover && mm_rollover;
    wire pm_en = hh_en && hh_rollover;

    // Seconds counter
    always @(posedge clk) begin
        if (reset) begin
            ss_reg <= 8'h00;
        end else if (ss_en) begin
            if (ss_reg[3:0] == 4'h9) begin
                ss_reg[3:0] <= 4'h0;
                ss_reg[7:4] <= (ss_reg[7:4] == 4'h5) ? 4'h0 : ss_reg[7:4] + 1;
            end else begin
                ss_reg[3:0] <= ss_reg[3:0] + 1;
            end
        end
    end

    // Minutes counter
    always @(posedge clk) begin
        if (reset) begin
            mm_reg <= 8'h00;
        end else if (mm_en) begin
            if (mm_reg[3:0] == 4'h9) begin
                mm_reg[3:0] <= 4'h0;
                mm_reg[7:4] <= (mm_reg[7:4] == 4'h5) ? 4'h0 : mm_reg[7:4] + 1;
            end else begin
                mm_reg[3:0] <= mm_reg[3:0] + 1;
            end
        end
    end

    // Hours and PM counter
    always @(posedge clk) begin
        if (reset) begin
            hh_reg <= 8'h12;
            pm_reg <= 1'b0;
        end else if (hh_en) begin
            if (hh_rollover) begin
                hh_reg <= 8'h12;
                if (pm_en) pm_reg <= ~pm_reg;
            end else if (hh_reg == 8'h12) begin
                hh_reg <= 8'h01;
            end else if (hh_reg[3:0] == 4'h9) begin
                hh_reg[3:0] <= 4'h0;
                hh_reg[7:4] <= hh_reg[7:4] + 1;
            end else begin
                hh_reg[3:0] <= hh_reg[3:0] + 1;
            end
        end
    end

    // Output assignments
    assign pm = pm_reg;
    assign ss = ss_reg;
    assign mm = mm_reg;
    assign hh = hh_reg;

endmodule