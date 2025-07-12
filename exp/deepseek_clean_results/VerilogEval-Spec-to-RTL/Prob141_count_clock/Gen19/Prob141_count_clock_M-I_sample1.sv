module TopModule (
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

    reg pm_reg;
    reg [3:0] hour_tens, hour_ones;  // BCD hours (01-12)
    reg [3:0] min_tens, min_ones;   // BCD minutes
    reg [3:0] sec_tens, sec_ones;    // BCD seconds
    
    // Registered rollover flags
    reg ss_roll, mm_roll;
    
    // Seconds counter
    always @(posedge clk) begin
        if (reset) begin
            sec_tens <= 4'd0;
            sec_ones <= 4'd0;
            ss_roll <= 1'b0;
        end else if (ena) begin
            if (sec_ones == 4'd9) begin
                sec_ones <= 4'd0;
                if (sec_tens == 4'd5) begin
                    sec_tens <= 4'd0;
                    ss_roll <= 1'b1;
                end else begin
                    sec_tens <= sec_tens + 1;
                    ss_roll <= 1'b0;
                end
            end else begin
                sec_ones <= sec_ones + 1;
                ss_roll <= 1'b0;
            end
        end else begin
            ss_roll <= 1'b0;
        end
    end

    // Minutes counter
    always @(posedge clk) begin
        if (reset) begin
            min_tens <= 4'd0;
            min_ones <= 4'd0;
            mm_roll <= 1'b0;
        end else if (ena && ss_roll) begin
            if (min_ones == 4'd9) begin
                min_ones <= 4'd0;
                if (min_tens == 4'd5) begin
                    min_tens <= 4'd0;
                    mm_roll <= 1'b1;
                end else begin
                    min_tens <= min_tens + 1;
                    mm_roll <= 1'b0;
                end
            end else begin
                min_ones <= min_ones + 1;
                mm_roll <= 1'b0;
            end
        end else begin
            mm_roll <= 1'b0;
        end
    end

    // Hours and PM logic
    always @(posedge clk) begin
        if (reset) begin
            hour_tens <= 4'd1;
            hour_ones <= 4'd2;
            pm_reg <= 1'b0;
        end else if (ena && mm_roll) begin
            if (hour_ones == 4'd2 && hour_tens == 4'd1) begin
                hour_tens <= 4'd0;
                hour_ones <= 4'd1;
                pm_reg <= ~pm_reg;
            end else if (hour_ones == 4'd9) begin
                hour_ones <= 4'd0;
                hour_tens <= hour_tens + 1;
            end else begin
                hour_ones <= hour_ones + 1;
            end
        end
    end

    // Output assignments
    assign ss = {sec_tens, sec_ones};
    assign mm = {min_tens, min_ones};
    assign hh = {hour_tens, hour_ones};
    assign pm = pm_reg;

endmodule