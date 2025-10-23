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
    wire sec_rollover = (ss_reg == 8'h59);
    wire min_rollover = (mm_reg == 8'h59) && sec_rollover;
    wire hour_inc = min_rollover && ena;
    wire pm_toggle = (hh_reg == 8'h11) && hour_inc;

    // Clock gating for PM indicator
    wire pm_clk_en = pm_toggle || reset;
    wire pm_clk = pm_clk_en ? clk : 1'b0;

    // Consolidated reset and counter logic
    always @(posedge clk) begin
        if (reset) begin
            ss_reg <= 8'h00;
            mm_reg <= 8'h00;
            hh_reg <= 8'h12;
        end
        else if (ena) begin
            // Seconds counter
            case (ss_reg)
                8'h59: ss_reg <= 8'h00;
                default: begin
                    if (ss_reg[3:0] == 4'd9) begin
                        ss_reg[3:0] <= 4'd0;
                        ss_reg[7:4] <= ss_reg[7:4] + 1;
                    end
                    else begin
                        ss_reg[3:0] <= ss_reg[3:0] + 1;
                    end
                end
            endcase

            // Minutes counter (triggered by second rollover)
            if (sec_rollover) begin
                case (mm_reg)
                    8'h59: mm_reg <= 8'h00;
                    default: begin
                        if (mm_reg[3:0] == 4'd9) begin
                            mm_reg[3:0] <= 4'd0;
                            mm_reg[7:4] <= mm_reg[7:4] + 1;
                        end
                        else begin
                            mm_reg[3:0] <= mm_reg[3:0] + 1;
                        end
                    end
                endcase
            end

            // Hours counter (triggered by minute rollover)
            if (min_rollover) begin
                case (hh_reg)
                    8'h12: hh_reg <= 8'h01;
                    default: begin
                        if (hh_reg[3:0] == 4'd9) begin
                            hh_reg <= {4'd1, 4'd0};
                        end
                        else begin
                            hh_reg[3:0] <= hh_reg[3:0] + 1;
                        end
                    end
                endcase
            end
        end
    end

    // PM indicator with clock gating
    always @(posedge pm_clk) begin
        if (reset) begin
            pm_reg <= 1'b0;
        end
        else if (pm_toggle) begin
            pm_reg <= ~pm_reg;
        end
    end

    // Output assignments
    assign pm = pm_reg;
    assign ss = ss_reg;
    assign mm = mm_reg;
    assign hh = hh_reg;

endmodule