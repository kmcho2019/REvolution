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
    parameter BCD_9 = 4'd9;
    parameter BCD_5 = 4'd5;
    parameter BCD_1 = 4'd1;
    parameter BCD_2 = 4'd2;
    parameter BCD_0 = 4'd0;

    // Seconds counter
    reg [3:0] sec_ones;
    reg [3:0] sec_tens;
    
    // Minutes counter
    reg [3:0] min_ones;
    reg [3:0] min_tens;
    
    // Hours counter (1-12)
    reg [3:0] hour;
    reg pm_reg;

    // BCD conversion for hours
    wire [3:0] hour_tens = (hour > 4'd9) ? 4'd1 : 4'd0;
    wire [3:0] hour_ones = (hour > 4'd9) ? (hour - 4'd10) : hour;

    // Assign outputs
    assign ss = {sec_tens, sec_ones};
    assign mm = {min_tens, min_ones};
    assign hh = {hour_tens, hour_ones};
    assign pm = pm_reg;

    // Seconds counter
    always @(posedge clk) begin
        if (reset) begin
            sec_ones <= BCD_0;
            sec_tens <= BCD_0;
        end else if (ena) begin
            if (sec_ones == BCD_9) begin
                sec_ones <= BCD_0;
                if (sec_tens == BCD_5) begin
                    sec_tens <= BCD_0;
                end else begin
                    sec_tens <= sec_tens + 1;
                end
            end else begin
                sec_ones <= sec_ones + 1;
            end
        end
    end

    // Minutes counter (triggered by seconds rollover)
    wire min_inc = ena & (sec_ones == BCD_9) & (sec_tens == BCD_5);
    
    always @(posedge clk) begin
        if (reset) begin
            min_ones <= BCD_0;
            min_tens <= BCD_0;
        end else if (min_inc) begin
            if (min_ones == BCD_9) begin
                min_ones <= BCD_0;
                if (min_tens == BCD_5) begin
                    min_tens <= BCD_0;
                end else begin
                    min_tens <= min_tens + 1;
                end
            end else begin
                min_ones <= min_ones + 1;
            end
        end
    end

    // Hours counter and AM/PM (triggered by minutes rollover)
    wire hour_inc = min_inc & (min_ones == BCD_9) & (min_tens == BCD_5);
    
    always @(posedge clk) begin
        if (reset) begin
            hour <= 4'd12;  // 12 o'clock
            pm_reg <= 1'b0; // AM
        end else if (hour_inc) begin
            if (hour == 4'd12) begin
                hour <= 4'd1;
                pm_reg <= ~pm_reg; // Toggle AM/PM at 12->1 transition
            end else begin
                hour <= hour + 1;
            end
        end
    end

endmodule