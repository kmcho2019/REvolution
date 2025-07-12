module TopModule (
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

    // Packed BCD registers (from Example 1)
    reg [7:0] ss_reg;  // ss_reg[7:4] = tens, ss_reg[3:0] = ones
    reg [7:0] mm_reg;
    reg [3:0] hour;    // 1-12 counter (from Example 2)

    // Internal signals (optimized combination)
    wire sec_rollover = (ss_reg == 8'h59);
    wire min_rollover = (mm_reg == 8'h59) && sec_rollover;
    wire hour_inc = ena && min_rollover;

    // PM indicator (combinational from Example 2)
    reg pm_reg;
    assign pm = pm_reg;

    // Seconds counter (00-59) - parallel structure from Example 1
    always @(posedge clk) begin
        if (reset) begin
            ss_reg <= 8'h00;
        end
        else if (ena) begin
            if (ss_reg[3:0] == 4'd9) begin
                ss_reg[3:0] <= 4'd0;
                ss_reg[7:4] <= (ss_reg[7:4] == 4'd5) ? 4'd0 : ss_reg[7:4] + 1;
            end
            else begin
                ss_reg[3:0] <= ss_reg[3:0] + 1;
            end
        end
    end

    // Minutes counter (00-59) - parallel structure from Example 1
    always @(posedge clk) begin
        if (reset) begin
            mm_reg <= 8'h00;
        end
        else if (ena && sec_rollover) begin
            if (mm_reg[3:0] == 4'd9) begin
                mm_reg[3:0] <= 4'd0;
                mm_reg[7:4] <= (mm_reg[7:4] == 4'd5) ? 4'd0 : mm_reg[7:4] + 1;
            end
            else begin
                mm_reg[3:0] <= mm_reg[3:0] + 1;
            end
        end
    end

    // Hours counter (1-12) - simplified from Example 2
    always @(posedge clk) begin
        if (reset) begin
            hour <= 4'd12;
            pm_reg <= 1'b0;
        end
        else if (hour_inc) begin
            if (hour == 4'd12) begin
                hour <= 4'd1;
            end
            else begin
                hour <= hour + 1;
            end
            
            // Toggle PM at 11->12 transition
            if (hour == 4'd11) begin
                pm_reg <= ~pm_reg;
            end
        end
    end

    // BCD outputs (combinational from Example 2)
    wire [3:0] hr_tens = (hour > 4'd9) ? 4'd1 : 4'd0;
    wire [3:0] hr_ones = (hour > 4'd9) ? hour - 4'd10 : hour;

    assign ss = ss_reg;
    assign mm = mm_reg;
    assign hh = {hr_tens, hr_ones};

endmodule