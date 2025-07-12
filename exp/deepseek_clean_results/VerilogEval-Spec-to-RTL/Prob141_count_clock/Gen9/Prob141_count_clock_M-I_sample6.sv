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
    reg [7:0] ss_reg;
    reg [7:0] mm_reg;
    reg [7:0] hh_reg;
    wire sec_rollover = (ss_reg == 8'h59);
    wire min_rollover = (mm_reg == 8'h59) && sec_rollover;
    wire hour_inc = min_rollover && ena;

    // Clock gating for PM register (only toggles once per 12 hours)
    wire pm_toggle = (hh_reg == 8'h11) && hour_inc;
    wire pm_clk_en = pm_toggle || reset;
    wire pm_clk = pm_clk_en ? clk : 1'b0;

    // Seconds counter with carry lookahead
    always @(posedge clk) begin
        if (reset) begin
            ss_reg <= 8'h00;
        end
        else if (ena) begin
            case (ss_reg)
                8'h59: ss_reg <= 8'h00;
                default: begin
                    if (ss_reg[3:0] == 4'h9) begin
                        ss_reg <= {ss_reg[7:4] + 4'h1, 4'h0};
                    end
                    else begin
                        ss_reg <= ss_reg + 8'h01;
                    end
                end
            endcase
        end
    end

    // Minutes counter with carry lookahead
    always @(posedge clk) begin
        if (reset) begin
            mm_reg <= 8'h00;
        end
        else if (ena && sec_rollover) begin
            case (mm_reg)
                8'h59: mm_reg <= 8'h00;
                default: begin
                    if (mm_reg[3:0] == 4'h9) begin
                        mm_reg <= {mm_reg[7:4] + 4'h1, 4'h0};
                    end
                    else begin
                        mm_reg <= mm_reg + 8'h01;
                    end
                end
            endcase
        end
    end

    // Hours counter - optimized state machine
    always @(posedge clk) begin
        if (reset) begin
            hh_reg <= 8'h12;
        end
        else if (hour_inc) begin
            case (hh_reg)
                8'h12: hh_reg <= 8'h01;
                8'h09: hh_reg <= 8'h10;
                8'h11: hh_reg <= 8'h12;
                default: hh_reg <= hh_reg + 8'h01;
            endcase
        end
    end

    // PM indicator (clock gated)
    always @(posedge pm_clk) begin
        if (reset) begin
            pm_reg <= 1'b0;
        end
        else if (pm_toggle) begin
            pm_reg <= ~pm_reg;
        end
    end

    assign pm = pm_reg;
    assign ss = ss_reg;
    assign mm = mm_reg;
    assign hh = hh_reg;

endmodule