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
    reg [7:0] ss_reg;  // packed BCD: ss_reg[7:4] = tens, ss_reg[3:0] = units
    reg [7:0] mm_reg;
    reg [7:0] hh_reg;

    // Seconds counter
    always @(posedge clk) begin
        if (reset) begin
            ss_reg <= 8'h00;
        end
        else if (ena) begin
            if (ss_reg[3:0] == 4'd9) begin
                ss_reg[3:0] <= 0;
                if (ss_reg[7:4] == 4'd5) begin
                    ss_reg[7:4] <= 0;
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
    always @(posedge clk) begin
        if (reset) begin
            mm_reg <= 8'h00;
        end
        else if (ena && ss_reg == 8'h59) begin
            if (mm_reg[3:0] == 4'd9) begin
                mm_reg[3:0] <= 0;
                if (mm_reg[7:4] == 4'd5) begin
                    mm_reg[7:4] <= 0;
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

    // Hours counter and PM indicator (triggered by minutes rollover)
    always @(posedge clk) begin
        if (reset) begin
            hh_reg <= 8'h12;
            pm_reg <= 0;
        end
        else if (ena && ss_reg == 8'h59 && mm_reg == 8'h59) begin
            // Handle hour increment
            if (hh_reg == 8'h12) begin
                hh_reg <= 8'h01;
            end
            else if (hh_reg[3:0] == 4'd9) begin
                hh_reg <= {hh_reg[7:4] + 1, 4'd0};
            end
            else begin
                hh_reg[3:0] <= hh_reg[3:0] + 1;
            end

            // Toggle PM at 11->12 transition
            if (hh_reg == 8'h11) begin
                pm_reg <= ~pm_reg;
            end
        end
    end

    // Direct output assignments
    assign pm = pm_reg;
    assign ss = ss_reg;
    assign mm = mm_reg;
    assign hh = hh_reg;

endmodule