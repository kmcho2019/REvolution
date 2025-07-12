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
    wire pm_toggle;

    // Rollover detection signals
    assign sec_rollover = (ss_reg == 8'h59) & ena;
    assign min_rollover = (mm_reg == 8'h59) & sec_rollover;
    assign pm_toggle = (hh_reg == 8'h11) & min_rollover;

    // Seconds counter with case statement
    always @(posedge clk) begin
        if (reset) begin
            ss_reg <= 8'h00;
        end
        else if (ena) begin
            case (ss_reg[3:0])
                4'd9: begin
                    ss_reg[3:0] <= 4'd0;
                    ss_reg[7:4] <= (ss_reg[7:4] == 4'd5) ? 4'd0 : ss_reg[7:4] + 1;
                end
                default: ss_reg[3:0] <= ss_reg[3:0] + 1;
            endcase
        end
    end

    // Minutes counter with case statement
    always @(posedge clk) begin
        if (reset) begin
            mm_reg <= 8'h00;
        end
        else if (sec_rollover) begin
            case (mm_reg[3:0])
                4'd9: begin
                    mm_reg[3:0] <= 4'd0;
                    mm_reg[7:4] <= (mm_reg[7:4] == 4'd5) ? 4'd0 : mm_reg[7:4] + 1;
                end
                default: mm_reg[3:0] <= mm_reg[3:0] + 1;
            endcase
        end
    end

    // Hours counter with simplified logic
    always @(posedge clk) begin
        if (reset) begin
            hh_reg <= 8'h12;
        end
        else if (min_rollover) begin
            if (hh_reg == 8'h12) begin
                hh_reg <= 8'h01;
            end
            else if (hh_reg[3:0] == 4'd9) begin
                hh_reg <= 8'h10;
            end
            else begin
                hh_reg[3:0] <= hh_reg[3:0] + 1;
            end
        end
    end

    // Clock-gated PM register (only toggles twice per day)
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