module TopModule (
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

    reg [3:0] sec_ones, sec_tens;
    reg [3:0] min_ones, min_tens;
    reg [3:0] hour;  // 1-12 counter
    reg pm_reg;
    reg [7:0] hh_reg, mm_reg, ss_reg;
    
    wire sec_rollover = ena & (sec_ones == 4'd9) & (sec_tens == 4'd5);
    wire min_rollover = sec_rollover & (min_ones == 4'd9) & (min_tens == 4'd5);

    // Seconds counter
    always @(posedge clk) begin
        if (reset) begin
            sec_ones <= 4'd0;
            sec_tens <= 4'd0;
        end else if (ena) begin
            if (sec_ones == 4'd9) begin
                sec_ones <= 4'd0;
                sec_tens <= (sec_tens == 4'd5) ? 4'd0 : sec_tens + 1;
            end else begin
                sec_ones <= sec_ones + 1;
            end
        end
        ss_reg <= {sec_tens, sec_ones};
    end

    // Minutes counter
    always @(posedge clk) begin
        if (reset) begin
            min_ones <= 4'd0;
            min_tens <= 4'd0;
        end else if (sec_rollover) begin
            if (min_ones == 4'd9) begin
                min_ones <= 4'd0;
                min_tens <= (min_tens == 4'd5) ? 4'd0 : min_tens + 1;
            end else begin
                min_ones <= min_ones + 1;
            end
        end
        mm_reg <= {min_tens, min_ones};
    end

    // Hours and PM counter
    always @(posedge clk) begin
        if (reset) begin
            hour <= 4'd12;
            pm_reg <= 1'b0;
        end else if (min_rollover) begin
            if (hour == 4'd12)
                hour <= 4'd1;
            else
                hour <= hour + 1;
            
            if (hour == 4'd11) pm_reg <= ~pm_reg;
        end
        
        // BCD conversion for hours (registered)
        hh_reg <= (hour > 4'd9) ? {4'd1, hour - 4'd10} : {4'd0, hour};
    end

    assign pm = pm_reg;
    assign hh = hh_reg;
    assign mm = mm_reg;
    assign ss = ss_reg;

endmodule