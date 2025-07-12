module TopModule (
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

    // Seconds counter (0-59)
    reg [3:0] sec_ones, sec_tens;
    wire sec_inc = ena;
    wire sec_roll = (sec_ones == 4'd9) && (sec_tens == 4'd5) && sec_inc;

    always @(posedge clk) begin
        if (reset) begin
            sec_ones <= 4'd0;
            sec_tens <= 4'd0;
        end else if (sec_inc) begin
            if (sec_ones == 4'd9) begin
                sec_ones <= 4'd0;
                sec_tens <= sec_tens + (sec_tens != 4'd5);
            end else begin
                sec_ones <= sec_ones + 1;
            end
        end
    end

    // Minutes counter (0-59)
    reg [3:0] min_ones, min_tens;
    wire min_inc = sec_roll;
    wire min_roll = (min_ones == 4'd9) && (min_tens == 4'd5) && min_inc;

    always @(posedge clk) begin
        if (reset) begin
            min_ones <= 4'd0;
            min_tens <= 4'd0;
        end else if (min_inc) begin
            if (min_ones == 4'd9) begin
                min_ones <= 4'd0;
                min_tens <= min_tens + (min_tens != 4'd5);
            end else begin
                min_ones <= min_ones + 1;
            end
        end
    end

    // Hours counter (1-12)
    reg [4:0] hours; // Stores 1-12 directly
    reg pm_reg;
    wire hr_inc = min_roll;

    always @(posedge clk) begin
        if (reset) begin
            hours <= 5'd12;
            pm_reg <= 1'b0;
        end else if (hr_inc) begin
            if (hours == 5'd12) begin
                hours <= 5'd1;
                pm_reg <= ~pm_reg;
            end else begin
                hours <= hours + 1;
            end
        end
    end

    // Convert hours to BCD
    wire [3:0] hr_tens = (hours < 10) ? 4'd0 : 4'd1;
    wire [3:0] hr_ones = (hours < 10) ? hours[3:0] : hours - 10;

    assign ss = {sec_tens, sec_ones};
    assign mm = {min_tens, min_ones};
    assign hh = {hr_tens, hr_ones};
    assign pm = pm_reg;

endmodule