module TopModule (
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

    // Constants for BCD values
    parameter BCD_0 = 4'd0;
    parameter BCD_1 = 4'd1;
    parameter BCD_5 = 4'd5;
    parameter BCD_9 = 4'd9;
    parameter BCD_10 = 4'd10;
    parameter BCD_12 = 4'd12;

    // Counter registers
    reg [3:0] sec_ones, sec_tens;
    reg [3:0] min_ones, min_tens;
    reg [3:0] hour;  // 1-12 counter
    
    // Continuous assignments for increment conditions
    wire sec_rollover = (sec_ones == BCD_9) && (sec_tens == BCD_5);
    wire min_rollover = (min_ones == BCD_9) && (min_tens == BCD_5);
    wire hour_rollover = (hour == BCD_12);
    
    // Seconds counter (00-59)
    always @(posedge clk) begin
        if (reset) begin
            sec_ones <= BCD_0;
            sec_tens <= BCD_0;
        end else if (ena) begin
            sec_ones <= (sec_ones == BCD_9) ? BCD_0 : sec_ones + 1;
            sec_tens <= (sec_rollover) ? BCD_0 : 
                       (sec_ones == BCD_9) ? sec_tens + 1 : sec_tens;
        end
    end

    // Minutes counter (00-59)
    always @(posedge clk) begin
        if (reset) begin
            min_ones <= BCD_0;
            min_tens <= BCD_0;
        end else if (ena && sec_rollover) begin
            min_ones <= (min_ones == BCD_9) ? BCD_0 : min_ones + 1;
            min_tens <= (min_rollover) ? BCD_0 : 
                       (min_ones == BCD_9) ? min_tens + 1 : min_tens;
        end
    end

    // Hours counter (1-12) with explicit state transitions
    always @(posedge clk) begin
        if (reset) begin
            hour <= BCD_12;
        end else if (ena && sec_rollover && min_rollover) begin
            hour <= (hour_rollover) ? BCD_1 : hour + 1;
        end
    end

    // PM indicator (combinational based on hour count)
    // Toggles when passing 11->12 (AM->PM or PM->AM)
    wire pm_next = (hour == BCD_11) ? ~pm : pm;
    reg pm_reg;
    always @(posedge clk) begin
        if (reset) begin
            pm_reg <= 1'b0;
        end else if (ena && sec_rollover && min_rollover && hour == BCD_11) begin
            pm_reg <= pm_next;
        end
    end

    // BCD outputs (combinational)
    wire [3:0] hr_tens = (hour > BCD_9) ? BCD_1 : BCD_0;
    wire [3:0] hr_ones = (hour > BCD_9) ? hour - BCD_10 : hour;

    assign pm = pm_reg;
    assign ss = {sec_tens, sec_ones};
    assign mm = {min_tens, min_ones};
    assign hh = {hr_tens, hr_ones};

endmodule