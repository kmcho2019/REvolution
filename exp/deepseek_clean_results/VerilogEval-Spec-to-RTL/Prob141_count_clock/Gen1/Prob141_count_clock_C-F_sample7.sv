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
    reg [3:0] hr_ones, hr_tens;
    reg pm_reg;
    wire min_rollover, hr_rollover;

    // Rollover signals
    assign min_rollover = (sec_ones == 4'd9) && (sec_tens == 4'd5);
    assign hr_rollover = (min_ones == 4'd9) && (min_tens == 4'd5) && min_rollover;

    always @(posedge clk) begin
        if (reset) begin
            // Reset to 12:00:00 AM
            sec_ones <= 4'd0;
            sec_tens <= 4'd0;
            min_ones <= 4'd0;
            min_tens <= 4'd0;
            hr_ones <= 4'd2;
            hr_tens <= 4'd1;
            pm_reg <= 1'b0;
        end else if (ena) begin
            // Seconds counter
            if (sec_ones == 4'd9) begin
                sec_ones <= 4'd0;
                if (sec_tens == 4'd5)
                    sec_tens <= 4'd0;
                else
                    sec_tens <= sec_tens + 1;
            end else begin
                sec_ones <= sec_ones + 1;
            end

            // Minutes counter (only on second rollover)
            if (min_rollover) begin
                if (min_ones == 4'd9) begin
                    min_ones <= 4'd0;
                    if (min_tens == 4'd5)
                        min_tens <= 4'd0;
                    else
                        min_tens <= min_tens + 1;
                end else begin
                    min_ones <= min_ones + 1;
                end
            end

            // Hours counter (only on minute rollover)
            if (hr_rollover) begin
                if ({hr_tens, hr_ones} == 8'h12) begin
                    hr_ones <= 4'd1;
                    hr_tens <= 4'd0;
                end else if (hr_ones == 4'd9) begin
                    hr_ones <= 4'd0;
                    hr_tens <= hr_tens + 1;
                end else begin
                    hr_ones <= hr_ones + 1;
                end

                // Toggle PM at 11->12 transition
                if ({hr_tens, hr_ones} == 8'h11)
                    pm_reg <= ~pm_reg;
            end
        end
    end

    assign ss = {sec_tens, sec_ones};
    assign mm = {min_tens, min_ones};
    assign hh = {hr_tens, hr_ones};
    assign pm = pm_reg;

endmodule