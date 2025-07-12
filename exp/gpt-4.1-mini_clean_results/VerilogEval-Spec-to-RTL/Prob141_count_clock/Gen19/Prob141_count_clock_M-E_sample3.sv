module TopModule(
    input  wire       clk,
    input  wire       reset,
    input  wire       ena,
    output reg        pm,
    output reg [7:0]  hh,
    output reg [7:0]  mm,
    output reg [7:0]  ss
);

    // Internal binary counters
    reg [5:0] seconds;  // 0-59
    reg [5:0] minutes;  // 0-59
    reg [3:0] hours;    // 1-12

    // Increment time on ena
    always @(posedge clk) begin
        if (reset) begin
            seconds <= 6'd0;
            minutes <= 6'd0;
            hours   <= 4'd12;
            pm      <= 1'b0;  // AM
        end else if (ena) begin
            // Increment seconds
            if (seconds == 6'd59) begin
                seconds <= 6'd0;
                // Increment minutes
                if (minutes == 6'd59) begin
                    minutes <= 6'd0;
                    // Increment hours
                    if (hours == 4'd11) begin
                        hours <= 4'd12;
                        pm <= ~pm;  // Toggle PM at 11->12 rollover
                    end else if (hours == 4'd12) begin
                        hours <= 4'd1;
                    end else begin
                        hours <= hours + 1;
                    end
                end else begin
                    minutes <= minutes + 1;
                end
            end else begin
                seconds <= seconds + 1;
            end
        end
    end

    // Function to convert 6-bit binary (0-59) to BCD (8 bits)
    // Using simple shift-add-3 double dabble algorithm for 6-bit input
    function [7:0] bin6_to_bcd8;
        input [5:0] bin_val;
        integer i;
        reg [7:0] bcd;
        reg [5:0] bin;
    begin
        bcd = 8'd0;
        bin = bin_val;
        for (i=5; i>=0; i=i-1) begin
            // Add 3 if needed
            if ((bcd[3:0]) > 4) bcd[3:0] = bcd[3:0] + 4'd3;
            if ((bcd[7:4]) > 4) bcd[7:4] = bcd[7:4] + 4'd3;
            // Shift left BCD by 1
            bcd = {bcd[6:0], bin[i]};
        end
        bin6_to_bcd8 = bcd;
    end
    endfunction

    // Function to convert 1-12 binary hours to BCD (8 bits)
    // Direct combinational mapping since range is limited
    function [7:0] bin4_to_bcd8_hour;
        input [3:0] bin_hour;
    begin
        if (bin_hour >= 10) begin
            bin4_to_bcd8_hour = {4'd1, bin_hour - 4'd10};
        end else begin
            bin4_to_bcd8_hour = {4'd0, bin_hour};
        end
    end
    endfunction

    // Convert binary counters to BCD outputs combinationally
    always @* begin
        hh = bin4_to_bcd8_hour(hours);
        mm = bin6_to_bcd8(minutes);
        ss = bin6_to_bcd8(seconds);
    end

endmodule