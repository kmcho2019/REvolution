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
    reg [7:0] ss_reg;  // BCD: tens[7:4], ones[3:0]
    reg [7:0] mm_reg;
    reg [7:0] hh_reg;

    // Gated enable signals
    wire sec_inc = ena;
    wire min_inc = ena && (ss_reg == 8'h59);
    wire hour_inc = min_inc && (mm_reg == 8'h59);

    // Seconds counter (00-59 BCD)
    always @(posedge clk) begin
        if (reset) begin
            ss_reg <= 8'h00;
        end else if (sec_inc) begin
            if (ss_reg[3:0] == 4'd9) begin
                ss_reg[3:0] <= 4'd0;
                ss_reg[7:4] <= (ss_reg[7:4] == 4'd5) ? 4'd0 : ss_reg[7:4] + 1;
            end else begin
                ss_reg[3:0] <= ss_reg[3:0] + 1;
            end
        end
    end

    // Minutes counter (00-59 BCD)
    always @(posedge clk) begin
        if (reset) begin
            mm_reg <= 8'h00;
        end else if (min_inc) begin
            if (mm_reg[3:0] == 4'd9) begin
                mm_reg[3:0] <= 4'd0;
                mm_reg[7:4] <= (mm_reg[7:4] == 4'd5) ? 4'd0 : mm_reg[7:4] + 1;
            end else begin
                mm_reg[3:0] <= mm_reg[3:0] + 1;
            end
        end
    end

    // Hours counter (01-12 BCD) and PM indicator
    always @(posedge clk) begin
        if (reset) begin
            hh_reg <= 8'h12;
            pm_reg <= 1'b0;
        end else if (hour_inc) begin
            // Handle hour increment in BCD
            if (hh_reg == 8'h12) begin
                hh_reg <= 8'h01;
            end else if (hh_reg[3:0] == 4'd9) begin
                hh_reg[7:4] <= 4'd1;
                hh_reg[3:0] <= 4'd0;
            end else begin
                hh_reg[3:0] <= hh_reg[3:0] + 1;
            end

            // Toggle PM at 11->12 transition
            if (hh_reg == 8'h11) begin
                pm_reg <= ~pm_reg;
            end
        end
    end

    // Output assignments
    assign pm = pm_reg;
    assign ss = ss_reg;
    assign mm = mm_reg;
    assign hh = hh_reg;

endmodule