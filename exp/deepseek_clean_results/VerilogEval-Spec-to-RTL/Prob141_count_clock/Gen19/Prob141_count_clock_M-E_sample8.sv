module TopModule (
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

    // State registers
    reg [3:0] sec_ones, sec_tens;
    reg [3:0] min_ones, min_tens;
    reg [3:0] hour;
    reg pm_reg;

    // Predictive rollover signals (asserted one cycle before actual rollover)
    wire sec_will_roll = (sec_ones == 4'd8) && (sec_tens == 4'd5) && ena;
    wire min_will_roll = (min_ones == 4'd8) && (min_tens == 4'd5) && sec_will_roll;
    wire hour_will_inc = min_will_roll;

    // Continuous output assignments
    assign ss = {sec_tens, sec_ones};
    assign mm = {min_tens, min_ones};
    assign hh = (hour > 4'd9) ? {4'd1, hour - 4'd10} : {4'd0, hour};
    assign pm = pm_reg;

    // Seconds counter (00-59)
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
    end

    // Minutes counter (00-59)
    always @(posedge clk) begin
        if (reset) begin
            min_ones <= 4'd0;
            min_tens <= 4'd0;
        end else if (sec_will_roll) begin
            if (min_ones == 4'd9) begin
                min_ones <= 4'd0;
                min_tens <= (min_tens == 4'd5) ? 4'd0 : min_tens + 1;
            end else begin
                min_ones <= min_ones + 1;
            end
        end
    end

    // Hours counter (1-12) with PM logic
    always @(posedge clk) begin
        if (reset) begin
            hour <= 4'd12;
            pm_reg <= 1'b0;
        end else if (hour_will_inc) begin
            // Compute next hour and PM state combinatorially
            if (hour == 4'd12) begin
                hour <= 4'd1;
            end else begin
                hour <= hour + 1;
            end

            // PM toggles when crossing 11->12
            if (hour == 4'd11) begin
                pm_reg <= ~pm_reg;
            end
        end
    end

endmodule