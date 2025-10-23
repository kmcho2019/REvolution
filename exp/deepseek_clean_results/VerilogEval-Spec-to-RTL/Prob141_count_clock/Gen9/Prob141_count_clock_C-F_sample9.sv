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

    // Gated enable signals
    wire sec_inc = ena;
    wire min_inc = ena && (sec_ones == 4'd9) && (sec_tens == 4'd5);
    wire hour_inc = min_inc && (min_ones == 4'd9) && (min_tens == 4'd5);

    // Seconds counter (00-59 BCD)
    always @(posedge clk) begin
        if (reset) begin
            sec_ones <= 4'd0;
            sec_tens <= 4'd0;
        end else if (sec_inc) begin
            if (sec_ones == 4'd9) begin
                sec_ones <= 4'd0;
                sec_tens <= (sec_tens == 4'd5) ? 4'd0 : sec_tens + 1;
            end else begin
                sec_ones <= sec_ones + 1;
            end
        end
    end

    // Minutes counter (00-59 BCD)
    always @(posedge clk) begin
        if (reset) begin
            min_ones <= 4'd0;
            min_tens <= 4'd0;
        end else if (min_inc) begin
            if (min_ones == 4'd9) begin
                min_ones <= 4'd0;
                min_tens <= (min_tens == 4'd5) ? 4'd0 : min_tens + 1;
            end else begin
                min_ones <= min_ones + 1;
            end
        end
    end

    // Hours counter (1-12)
    always @(posedge clk) begin
        if (reset) begin
            hour <= 4'd12;
            pm_reg <= 1'b0;
        end else if (hour_inc) begin
            if (hour == 4'd12) begin
                hour <= 4'd1;
            end else begin
                hour <= hour + 1;
                // Toggle PM at 11->12 transition
                if (hour == 4'd11) pm_reg <= ~pm_reg;
            end
        end
    end

    // BCD conversion for hours (combinational)
    wire [3:0] hr_tens = (hour > 4'd9) ? 4'd1 : 4'd0;
    wire [3:0] hr_ones = (hour > 4'd9) ? hour - 4'd10 : hour;

    // Output assignments
    assign ss = {sec_tens, sec_ones};
    assign mm = {min_tens, min_ones};
    assign hh = {hr_tens, hr_ones};
    assign pm = pm_reg;

endmodule