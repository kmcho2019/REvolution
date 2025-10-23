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
    reg [7:0] ss_reg;  // packed BCD: [7:4] = tens, [3:0] = ones
    reg [7:0] mm_reg;
    reg [3:0] hour;    // 1-12 counter
    wire sec_rollover, min_rollover;

    // Gated rollover signals
    assign sec_rollover = ena && (ss_reg == 8'h59);
    assign min_rollover = sec_rollover && (mm_reg == 8'h59);

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
        end else if (sec_rollover) begin
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
            hour <= 4'd12;
            pm_reg <= 1'b0;
        end else if (min_rollover) begin
            if (hour == 4'd12)
                hour <= 4'd1;
            else
                hour <= hour + 1;
            
            // Toggle PM at 11->12 transition
            if (hour == 4'd11)
                pm_reg <= ~pm_reg;
        end
    end

    // BCD conversion for hours
    wire [3:0] hr_tens = (hour > 4'd9) ? 4'd1 : 4'd0;
    wire [3:0] hr_ones = (hour > 4'd9) ? hour - 4'd10 : hour;

    assign ss = ss_reg;
    assign mm = mm_reg;
    assign hh = {hr_tens, hr_ones};
    assign pm = pm_reg;

endmodule