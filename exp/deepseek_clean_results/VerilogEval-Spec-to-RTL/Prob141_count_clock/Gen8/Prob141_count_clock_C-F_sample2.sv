module TopModule (
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

    // Internal registers (separate digits for clarity)
    reg [3:0] sec_ones, sec_tens;
    reg [3:0] min_ones, min_tens;
    reg [3:0] hr_ones, hr_tens;
    reg pm_reg;
    
    // Cascade enable signals
    wire sec_overflow = (sec_ones == 4'd9) && (sec_tens == 4'd5);
    wire min_overflow = (min_ones == 4'd9) && (min_tens == 4'd5) && sec_overflow;
    wire hour_overflow = min_overflow;

    // Seconds counter
    always @(posedge clk) begin
        if (reset) begin
            sec_ones <= 4'd0;
            sec_tens <= 4'd0;
        end
        else if (ena) begin
            if (sec_ones == 4'd9) begin
                sec_ones <= 4'd0;
                if (sec_tens == 4'd5)
                    sec_tens <= 4'd0;
                else
                    sec_tens <= sec_tens + 1;
            end
            else
                sec_ones <= sec_ones + 1;
        end
    end

    // Minutes counter
    always @(posedge clk) begin
        if (reset) begin
            min_ones <= 4'd0;
            min_tens <= 4'd0;
        end
        else if (ena && sec_overflow) begin
            if (min_ones == 4'd9) begin
                min_ones <= 4'd0;
                if (min_tens == 4'd5)
                    min_tens <= 4'd0;
                else
                    min_tens <= min_tens + 1;
            end
            else
                min_ones <= min_ones + 1;
        end
    end

    // Hours counter and PM indicator
    always @(posedge clk) begin
        if (reset) begin
            hr_ones <= 4'd2;
            hr_tens <= 4'd1;
            pm_reg <= 1'b0;
        end
        else if (ena && hour_overflow) begin
            // Special case for 12 -> 1
            if ({hr_tens, hr_ones} == 8'h12) begin
                hr_ones <= 4'd1;
                hr_tens <= 4'd0;
            end
            // Regular BCD increment
            else if (hr_ones == 4'd9) begin
                hr_ones <= 4'd0;
                hr_tens <= 4'd1;
            end
            else
                hr_ones <= hr_ones + 1;
            
            // Toggle PM at 11->12 transition
            if ({hr_tens, hr_ones} == 8'h11)
                pm_reg <= ~pm_reg;
        end
    end

    // Packed output assignments
    assign ss = {sec_tens, sec_ones};
    assign mm = {min_tens, min_ones};
    assign hh = {hr_tens, hr_ones};
    assign pm = pm_reg;

endmodule