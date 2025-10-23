module TopModule (
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

    // Counter registers
    reg [3:0] sec_ones, sec_tens;
    reg [3:0] min_ones, min_tens;
    reg [3:0] hour;
    reg pm_reg;
    
    // Registered rollover signals
    reg sec_rollover_reg;
    reg min_rollover_reg;
    
    // Combinational rollover conditions
    wire sec_ones_max = (sec_ones == 4'd9);
    wire sec_tens_max = (sec_tens == 4'd5);
    wire min_ones_max = (min_ones == 4'd9);
    wire min_tens_max = (min_tens == 4'd5);
    
    // Rollover logic
    assign sec_rollover = ena && sec_ones_max && sec_tens_max;
    assign min_rollover = sec_rollover_reg && min_ones_max && min_tens_max;
    
    // Seconds counter (00-59)
    always @(posedge clk) begin
        if (reset) begin
            sec_ones <= 4'd0;
            sec_tens <= 4'd0;
            sec_rollover_reg <= 1'b0;
        end else if (ena) begin
            sec_rollover_reg <= sec_ones_max && sec_tens_max;
            if (sec_ones_max) begin
                sec_ones <= 4'd0;
                sec_tens <= sec_tens_max ? 4'd0 : sec_tens + 1;
            end else begin
                sec_ones <= sec_ones + 1;
            end
        end
    end

    // Minutes counter (00-59)
    always @(posedge clk) begin
        if (reset) begin
            min_ones <= 4'd0;
            min_tens <= 4'd0;
            min_rollover_reg <= 1'b0;
        end else if (sec_rollover_reg) begin
            min_rollover_reg <= min_ones_max && min_tens_max;
            if (min_ones_max) begin
                min_ones <= 4'd0;
                min_tens <= min_tens_max ? 4'd0 : min_tens + 1;
            end else begin
                min_ones <= min_ones + 1;
            end
        end
    end

    // Hours counter (1-12) and PM indicator
    always @(posedge clk) begin
        if (reset) begin
            hour <= 4'd12;
            pm_reg <= 1'b0;
        end else if (min_rollover_reg) begin
            hour <= (hour == 4'd12) ? 4'd1 : hour + 1;
            pm_reg <= (hour == 4'd11) ? ~pm_reg : pm_reg;
        end
    end

    // BCD conversion for hours (combinational)
    wire [3:0] hr_tens = (hour > 4'd9);
    wire [3:0] hr_ones = hour - (hr_tens ? 4'd10 : 4'd0);

    // Output assignments
    assign pm = pm_reg;
    assign ss = {sec_tens, sec_ones};
    assign mm = {min_tens, min_ones};
    assign hh = {hr_tens, hr_ones};

endmodule