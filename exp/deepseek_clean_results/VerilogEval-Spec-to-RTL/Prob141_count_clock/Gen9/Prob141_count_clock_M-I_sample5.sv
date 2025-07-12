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
    
    // Registered outputs
    reg [7:0] ss_reg, mm_reg, hh_reg;
    reg pm_out;

    // Overflow detection (parallel and gated with ena)
    wire sec_max = (sec_ones == 4'd9) && (sec_tens == 4'd5);
    wire min_max = (min_ones == 4'd9) && (min_tens == 4'd5);
    wire hour_max = (hr_ones == 4'd2) && (hr_tens == 4'd1); // 12 hours

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
        else if (ena && sec_max) begin
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

    // Hours counter and PM indicator (combined logic)
    always @(posedge clk) begin
        if (reset) begin
            hr_ones <= 4'd2;
            hr_tens <= 4'd1;
            pm_reg <= 1'b0;
        end
        else if (ena && sec_max && min_max) begin
            if (hour_max) begin
                hr_ones <= 4'd1;
                hr_tens <= 4'd0;
            end
            else if (hr_ones == 4'd9) begin
                hr_ones <= 4'd0;
                hr_tens <= hr_tens + 1;
            end
            else begin
                hr_ones <= hr_ones + 1;
            end
            
            // Toggle PM at 11->12 transition
            if ({hr_tens, hr_ones} == 8'h11)
                pm_reg <= ~pm_reg;
        end
    end

    // Output registers (reduce switching)
    always @(posedge clk) begin
        if (ena) begin
            ss_reg <= {sec_tens, sec_ones};
            mm_reg <= {min_tens, min_ones};
            hh_reg <= {hr_tens, hr_ones};
            pm_out <= pm_reg;
        end
    end

    assign ss = ss_reg;
    assign mm = mm_reg;
    assign hh = hh_reg;
    assign pm = pm_out;

endmodule