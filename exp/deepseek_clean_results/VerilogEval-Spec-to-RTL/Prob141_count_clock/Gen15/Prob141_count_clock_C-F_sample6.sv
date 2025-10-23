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
    reg [3:0] hour;    // Binary hour (1-12)
    reg [7:0] ss_reg;  // BCD seconds
    reg [7:0] mm_reg;  // BCD minutes
    
    // Rollover flags
    wire ss_roll = (ss_reg == 8'h59) && ena;
    wire mm_roll = (mm_reg == 8'h59) && ss_roll;
    
    // Pre-computed BCD hour output
    wire [3:0] hr_tens = (hour > 9) ? 4'd1 : 4'd0;
    wire [3:0] hr_ones = (hour > 9) ? hour - 4'd10 : hour;
    assign hh = {hr_tens, hr_ones};
    
    // Seconds counter (BCD)
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

    // Minutes counter (BCD)
    always @(posedge clk) begin
        if (reset) begin
            mm_reg <= 8'h00;
        end else if (ena && ss_roll) begin
            if (mm_reg[3:0] == 4'd9) begin
                mm_reg[3:0] <= 4'd0;
                mm_reg[7:4] <= (mm_reg[7:4] == 4'd5) ? 4'd0 : mm_reg[7:4] + 1;
            end else begin
                mm_reg[3:0] <= mm_reg[3:0] + 1;
            end
        end
    end

    // Hours and PM logic
    always @(posedge clk) begin
        if (reset) begin
            hour <= 4'd12;
            pm_reg <= 1'b0;
        end else if (ena && mm_roll) begin
            if (hour == 12) begin
                hour <= 4'd1;
            end else begin
                hour <= hour + 1;
                pm_reg <= (hour == 11) ? ~pm_reg : pm_reg;
            end
        end
    end

    // Output assignments
    assign ss = ss_reg;
    assign mm = mm_reg;
    assign pm = pm_reg;

endmodule