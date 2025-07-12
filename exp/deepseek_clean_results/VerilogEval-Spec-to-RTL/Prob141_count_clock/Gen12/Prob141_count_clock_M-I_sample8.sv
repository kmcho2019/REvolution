module TopModule (
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

    // Internal registers (separate digits for clarity)
    reg [3:0] sec_ones, sec_tens;
    reg [3:0] min_ones, min_tens;
    reg [3:0] hr_ones, hr_tens;
    reg pm_reg;
    
    // Overflow detection (parallel and gated)
    wire sec_overflow = ena && (sec_ones == 4'd9) && (sec_tens == 4'd5);
    wire min_overflow = ena && (min_ones == 4'd9) && (min_tens == 4'd5) && (sec_ones == 4'd9) && (sec_tens == 4'd5);
    wire hour_overflow = ena && (min_ones == 4'd9) && (min_tens == 4'd5) && (sec_ones == 4'd9) && (sec_tens == 4'd5);

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
        else if (ena && (sec_ones == 4'd9) && (sec_tens == 4'd5)) begin
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

    // Combined Hours counter and PM indicator
    always @(posedge clk) begin
        if (reset) begin
            hr_ones <= 4'd2;
            hr_tens <= 4'd1;
            pm_reg <= 1'b0;
        end
        else if (hour_overflow) begin
            // Handle hour increment and PM toggle together
            if ({hr_tens, hr_ones} == 8'h12) begin
                hr_ones <= 4'd1;
                hr_tens <= 4'd0;
            end
            else if ({hr_tens, hr_ones} == 8'h11) begin
                hr_ones <= 4'd2;
                hr_tens <= 4'd1;
                pm_reg <= ~pm_reg;
            end
            else if (hr_ones == 4'd9) begin
                hr_ones <= 4'd0;
                hr_tens <= 4'd1;
            end
            else begin
                hr_ones <= hr_ones + 1;
            end
        end
    end

    // Registered outputs (updated only when needed)
    always @(posedge clk) begin
        if (reset) begin
            ss <= 8'h00;
            mm <= 8'h00;
            hh <= 8'h12;
            pm <= 1'b0;
        end
        else if (ena) begin
            ss <= {sec_tens, sec_ones};
            mm <= {min_tens, min_ones};
            hh <= {hr_tens, hr_ones};
            pm <= pm_reg;
        end
    end

endmodule