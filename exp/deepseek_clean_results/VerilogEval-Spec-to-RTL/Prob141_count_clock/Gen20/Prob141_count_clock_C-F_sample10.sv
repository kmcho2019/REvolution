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
    reg [7:0] ss_reg;  // BCD: [7:4] = tens (0-5), [3:0] = ones (0-9)
    reg [7:0] mm_reg;  // Same format as ss_reg
    reg [7:0] hh_reg;  // BCD: [7:4] = tens (0-1), [3:0] = ones (0-9)
    wire sec_roll, min_roll;

    // Rollover detection
    assign sec_roll = ena && (ss_reg == 8'h59);
    assign min_roll = sec_roll && (mm_reg == 8'h59);

    // Seconds counter
    always @(posedge clk) begin
        if (reset) begin
            ss_reg <= 8'h00;
        end else if (ena) begin
            if (ss_reg[3:0] == 4'd9) begin
                ss_reg[3:0] <= 4'd0;
                ss_reg[7:4] <= (ss_reg[7:4] == 4'd5) ? 4'd0 : ss_reg[7:4] + 1;
            end else begin
                ss_reg[3:0] <= ss_reg[3:0] + 1;
            end
        end
    end

    // Minutes counter
    always @(posedge clk) begin
        if (reset) begin
            mm_reg <= 8'h00;
        end else if (sec_roll) begin
            if (mm_reg[3:0] == 4'd9) begin
                mm_reg[3:0] <= 4'd0;
                mm_reg[7:4] <= (mm_reg[7:4] == 4'd5) ? 4'd0 : mm_reg[7:4] + 1;
            end else begin
                mm_reg[3:0] <= mm_reg[3:0] + 1;
            end
        end
    end

    // Hours counter and PM logic
    always @(posedge clk) begin
        if (reset) begin
            hh_reg <= 8'h12;
            pm_reg <= 1'b0;
        end else if (min_roll) begin
            if (hh_reg == 8'h12) begin
                hh_reg <= 8'h01;
            end else if (hh_reg[3:0] == 4'd9) begin
                hh_reg <= {1'b1, 4'd0};  // 09 -> 10
            end else begin
                hh_reg[3:0] <= hh_reg[3:0] + 1;
                // Toggle PM at 11->12 transition
                if (hh_reg == 8'h11) pm_reg <= ~pm_reg;
            end
        end
    end

    // Output assignments
    assign pm = pm_reg;
    assign ss = ss_reg;
    assign mm = mm_reg;
    assign hh = hh_reg;

endmodule