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
    reg [3:0] ss_tens, ss_ones;  // BCD seconds digits
    reg [3:0] mm_tens, mm_ones;  // BCD minutes digits
    
    // Rollover flags
    wire ss_ones_roll = (ss_ones == 4'd9) && ena;
    wire ss_tens_roll = (ss_tens == 4'd5) && ss_ones_roll;
    wire mm_ones_roll = (mm_ones == 4'd9) && ss_tens_roll;
    wire mm_tens_roll = (mm_tens == 4'd5) && mm_ones_roll;
    
    // BCD outputs (continuous assignment)
    assign hh = (hour > 9) ? {4'd1, hour - 4'd10} : {4'd0, hour};
    assign mm = {mm_tens, mm_ones};
    assign ss = {ss_tens, ss_ones};
    assign pm = pm_reg;
    
    // Seconds counter (BCD)
    always @(posedge clk) begin
        if (reset) begin
            {ss_tens, ss_ones} <= 8'h00;
        end else if (ena) begin
            ss_ones <= (ss_ones_roll) ? 4'd0 : ss_ones + 1;
            ss_tens <= (ss_tens_roll) ? 4'd0 : 
                      (ss_ones_roll) ? ss_tens + 1 : ss_tens;
        end
    end

    // Minutes counter (BCD)
    always @(posedge clk) begin
        if (reset) begin
            {mm_tens, mm_ones} <= 8'h00;
        end else if (ss_tens_roll) begin
            mm_ones <= (mm_ones_roll) ? 4'd0 : mm_ones + 1;
            mm_tens <= (mm_tens_roll) ? 4'd0 : 
                      (mm_ones_roll) ? mm_tens + 1 : mm_tens;
        end
    end

    // Hours and PM logic
    always @(posedge clk) begin
        if (reset) begin
            hour <= 4'd12;
            pm_reg <= 1'b0;
        end else if (mm_tens_roll) begin
            hour <= (hour == 12) ? 4'd1 : hour + 1;
            pm_reg <= (hour == 11) ? ~pm_reg : pm_reg;
        end
    end

endmodule