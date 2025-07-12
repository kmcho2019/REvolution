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
    reg [7:0] ss_reg;  // packed BCD: ss_reg[7:4] = tens, ss_reg[3:0] = ones
    reg [7:0] mm_reg;
    reg [7:0] hh_reg;
    wire sec_rollover, min_rollover;
    wire hour_inc;
    wire pm_toggle;

    // Rollover indicators
    assign sec_rollover = (ss_reg == 8'h59);
    assign min_rollover = sec_rollover && (mm_reg == 8'h59);
    assign hour_inc = min_rollover && ena;
    assign pm_toggle = (hh_reg == 8'h11) && hour_inc;

    // Seconds counter with carry lookahead
    always @(posedge clk) begin
        if (reset) begin
            ss_reg <= 8'h00;
        end
        else if (ena) begin
            case ({ss_reg[7:4], ss_reg[3:0]})
                8'h59: ss_reg <= 8'h00;
                8'h0?: ss_reg <= {ss_reg[7:4], ss_reg[3:0] + 1};
                8'h1?: ss_reg <= {ss_reg[7:4], ss_reg[3:0] + 1};
                8'h2?: ss_reg <= {ss_reg[7:4], ss_reg[3:0] + 1};
                8'h3?: ss_reg <= {ss_reg[7:4], ss_reg[3:0] + 1};
                8'h4?: ss_reg <= {ss_reg[7:4], ss_reg[3:0] + 1};
                8'h5?: ss_reg <= {ss_reg[7:4], 4'h0};
                default: ss_reg <= {ss_reg[7:4] + 1, 4'h0};
            endcase
        end
    end

    // Minutes counter with carry lookahead
    always @(posedge clk) begin
        if (reset) begin
            mm_reg <= 8'h00;
        end
        else if (ena && sec_rollover) begin
            case ({mm_reg[7:4], mm_reg[3:0]})
                8'h59: mm_reg <= 8'h00;
                8'h0?: mm_reg <= {mm_reg[7:4], mm_reg[3:0] + 1};
                8'h1?: mm_reg <= {mm_reg[7:4], mm_reg[3:0] + 1};
                8'h2?: mm_reg <= {mm_reg[7:4], mm_reg[3:0] + 1};
                8'h3?: mm_reg <= {mm_reg[7:4], mm_reg[3:0] + 1};
                8'h4?: mm_reg <= {mm_reg[7:4], mm_reg[3:0] + 1};
                8'h5?: mm_reg <= {mm_reg[7:4], 4'h0};
                default: mm_reg <= {mm_reg[7:4] + 1, 4'h0};
            endcase
        end
    end

    // Hours counter with simplified logic
    always @(posedge clk) begin
        if (reset) begin
            hh_reg <= 8'h12;
        end
        else if (hour_inc) begin
            case (hh_reg)
                8'h12: hh_reg <= 8'h01;
                8'h01: hh_reg <= 8'h02;
                8'h02: hh_reg <= 8'h03;
                8'h03: hh_reg <= 8'h04;
                8'h04: hh_reg <= 8'h05;
                8'h05: hh_reg <= 8'h06;
                8'h06: hh_reg <= 8'h07;
                8'h07: hh_reg <= 8'h08;
                8'h08: hh_reg <= 8'h09;
                8'h09: hh_reg <= {4'h1, 4'h0};
                8'h10: hh_reg <= {4'h1, 4'h1};
                8'h11: hh_reg <= 8'h12;
                default: hh_reg <= 8'h01;
            endcase
        end
    end

    // Clock-gated PM indicator
    always @(posedge clk) begin
        if (reset) begin
            pm_reg <= 1'b0;
        end
        else if (pm_toggle) begin
            pm_reg <= ~pm_reg;
        end
    end

    // Direct output assignments
    assign pm = pm_reg;
    assign ss = ss_reg;
    assign mm = mm_reg;
    assign hh = hh_reg;

endmodule