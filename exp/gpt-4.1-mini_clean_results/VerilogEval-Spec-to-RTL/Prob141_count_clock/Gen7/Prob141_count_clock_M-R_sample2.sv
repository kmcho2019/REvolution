module TopModule (
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

    // Internal representation of hour (1 to 12)
    reg [3:0] hour_bin; // binary hour 1-12

    // BCD digits for minutes and seconds
    reg [3:0] min_tens, min_ones;
    reg [3:0] sec_tens, sec_ones;

    // Task to increment a BCD digit pair with decimal limit
    // Returns 1 if rollover occurred
    task bcd_inc_2digits(
        inout [3:0] tens,
        inout [3:0] ones,
        input [3:0] tens_limit,
        input [3:0] ones_limit,
        output reg rolled_over
    );
    begin
        if (ones == ones_limit) begin
            ones <= 4'd0;
            if (tens == tens_limit) begin
                tens <= 4'd0;
                rolled_over = 1'b1;
            end else begin
                tens <= tens + 4'd1;
                rolled_over = 1'b0;
            end
        end else begin
            ones <= ones + 4'd1;
            rolled_over = 1'b0;
        end
    end
    endtask

    // Increment seconds on enable
    reg sec_roll;
    always @(posedge clk) begin
        if (reset) begin
            sec_tens <= 4'd0;
            sec_ones <= 4'd0;
            sec_roll <= 1'b0;
        end else if (ena) begin
            bcd_inc_2digits(sec_tens, sec_ones, 4'd5, 4'd9, sec_roll);
        end else begin
            sec_roll <= 1'b0;
        end
    end

    // Increment minutes if seconds rolled over
    reg min_roll;
    always @(posedge clk) begin
        if (reset) begin
            min_tens <= 4'd0;
            min_ones <= 4'd0;
            min_roll <= 1'b0;
        end else if (ena && sec_roll) begin
            bcd_inc_2digits(min_tens, min_ones, 4'd5, 4'd9, min_roll);
        end else begin
            min_roll <= 1'b0;
        end
    end

    // Increment hours if minutes rolled over
    always @(posedge clk) begin
        if (reset) begin
            hour_bin <= 4'd12;
            pm <= 1'b0;
        end else if (ena && min_roll) begin
            if (hour_bin == 4'd11) begin
                hour_bin <= 4'd12;
                pm <= ~pm; // toggle PM at 11->12
            end else if (hour_bin == 4'd12) begin
                hour_bin <= 4'd1;
            end else begin
                hour_bin <= hour_bin + 4'd1;
            end
        end
    end

    // Convert binary hour (1-12) to BCD for output
    function [7:0] bin_to_bcd_hour;
        input [3:0] hour;
        begin
            if (hour < 10)
                bin_to_bcd_hour = {4'd0, hour};
            else
                bin_to_bcd_hour = {4'd1, hour - 4'd10};
        end
    endfunction

    // Output registers updated every clock cycle
    always @(posedge clk) begin
        if (reset) begin
            hh <= 8'd0;
            mm <= 8'd0;
            ss <= 8'd0;
        end else begin
            hh <= bin_to_bcd_hour(hour_bin);
            mm <= {min_tens, min_ones};
            ss <= {sec_tens, sec_ones};
        end
    end

endmodule