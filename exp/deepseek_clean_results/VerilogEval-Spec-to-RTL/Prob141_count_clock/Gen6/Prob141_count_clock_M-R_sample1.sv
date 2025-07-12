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
    reg [7:0] hh_reg;  // hours in BCD (01-12)
    reg [7:0] mm_reg;  // minutes in BCD (00-59)
    reg [7:0] ss_reg;  // seconds in BCD (00-59)

    // Seconds counter
    always @(posedge clk) begin
        if (reset) begin
            ss_reg <= 8'h00;
        end
        else if (ena) begin
            if (ss_reg[3:0] == 4'h9) begin
                ss_reg[3:0] <= 4'h0;
                if (ss_reg[7:4] == 4'h5) begin
                    ss_reg[7:4] <= 4'h0;
                end
                else begin
                    ss_reg[7:4] <= ss_reg[7:4] + 1;
                end
            end
            else begin
                ss_reg[3:0] <= ss_reg[3:0] + 1;
            end
        end
    end

    // Minutes counter (triggered by seconds rollover)
    wire min_inc = ena && (ss_reg == 8'h59);
    always @(posedge clk) begin
        if (reset) begin
            mm_reg <= 8'h00;
        end
        else if (min_inc) begin
            if (mm_reg[3:0] == 4'h9) begin
                mm_reg[3:0] <= 4'h0;
                if (mm_reg[7:4] == 4'h5) begin
                    mm_reg[7:4] <= 4'h0;
                end
                else begin
                    mm_reg[7:4] <= mm_reg[7:4] + 1;
                end
            end
            else begin
                mm_reg[3:0] <= mm_reg[3:0] + 1;
            end
        end
    end

    // Hours counter (triggered by minutes rollover)
    wire hour_inc = min_inc && (mm_reg == 8'h59);
    always @(posedge clk) begin
        if (reset) begin
            hh_reg <= 8'h12;
            pm_reg <= 1'b0;
        end
        else if (hour_inc) begin
            if (hh_reg == 8'h12) begin
                hh_reg <= 8'h01;
            end
            else if (hh_reg[3:0] == 4'h9) begin
                hh_reg <= {hh_reg[7:4] + 1, 4'h0};
            end
            else begin
                hh_reg[3:0] <= hh_reg[3:0] + 1;
            end

            // Toggle PM when going from 11 to 12
            if (hh_reg == 8'h11) begin
                pm_reg <= ~pm_reg;
            end
        end
    end

    // Output assignments
    assign pm = pm_reg;
    assign hh = hh_reg;
    assign mm = mm_reg;
    assign ss = ss_reg;

endmodule