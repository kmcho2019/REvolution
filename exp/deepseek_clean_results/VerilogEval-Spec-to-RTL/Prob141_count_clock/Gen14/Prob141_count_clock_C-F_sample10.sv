module TopModule (
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

    // Packed BCD registers
    reg [7:0] ss_reg;  // {tens[3:0], ones[3:0]}
    reg [7:0] mm_reg;
    reg [3:0] hour_reg;  // 1-12 counter
    
    // Internal signals
    wire sec_roll = (ss_reg == 8'h59);
    wire min_roll = (mm_reg == 8'h59) && sec_roll;
    
    // Seconds counter (00-59)
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

    // Minutes counter (00-59)
    always @(posedge clk) begin
        if (reset) begin
            mm_reg <= 8'h00;
        end
        else if (ena && sec_roll) begin
            if (mm_reg[3:0] == 4'd9) begin
                mm_reg[3:0] <= 4'd0;
                mm_reg[7:4] <= (mm_reg[7:4] == 4'd5) ? 4'd0 : mm_reg[7:4] + 1;
            end
            else begin
                mm_reg[3:0] <= mm_reg[3:0] + 1;
            end
        end
    end

    // Hours counter (1-12)
    always @(posedge clk) begin
        if (reset) begin
            hour_reg <= 4'd12;
        end
        else if (ena && min_roll) begin
            hour_reg <= (hour_reg == 4'd12) ? 4'd1 : hour_reg + 1;
        end
    end

    // PM indicator (combinational)
    reg pm_reg;
    always @(posedge clk) begin
        if (reset) begin
            pm_reg <= 1'b0;
        end
        else if (ena && min_roll && hour_reg == 4'd11) begin
            pm_reg <= ~pm_reg;
        end
    end

    // BCD outputs
    wire [3:0] hr_tens = (hour_reg > 4'd9) ? 4'd1 : 4'd0;
    wire [3:0] hr_ones = (hour_reg > 4'd9) ? hour_reg - 4'd10 : hour_reg;

    assign pm = pm_reg;
    assign ss = ss_reg;
    assign mm = mm_reg;
    assign hh = {hr_tens, hr_ones};

endmodule