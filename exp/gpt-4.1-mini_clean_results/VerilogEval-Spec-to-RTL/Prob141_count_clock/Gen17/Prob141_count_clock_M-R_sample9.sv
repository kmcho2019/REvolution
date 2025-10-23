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
    reg [5:0] seconds; // 0-59
    reg [5:0] minutes; // 0-59
    reg [3:0] hours;   // 1-12

    // Internal pm toggle state (registered)
    reg pm_next;

    // Binary counter increment logic with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            seconds <= 6'd0;
            minutes <= 6'd0;
            hours   <= 4'd12;
            pm      <= 1'b0; // AM
        end else if (ena) begin
            if (seconds == 6'd59) begin
                seconds <= 6'd0;
                if (minutes == 6'd59) begin
                    minutes <= 6'd0;
                    if (hours == 4'd12) begin
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

    // PM toggle logic: toggle pm when hour transitions from 11 to 12
    // Detect next hour based on current counters and increment
    always @(posedge clk) begin
        if (reset) begin
            pm <= 1'b0;
        end else if (ena) begin
            // When seconds and minutes roll over to zero, hour increments
            if ((seconds == 6'd59) && (minutes == 6'd59)) begin
                // If hour was 11, toggling pm on hour increment to 12
                if (hours == 4'd11) begin
                    pm <= ~pm;
                end
            end
        end
    end

    // Combinational BCD conversion helper: tens digit 0-5 for minutes/seconds
    function [3:0] to_bcd_tens_0_5;
        input [5:0] val;
        begin
            if (val >= 50) to_bcd_tens_0_5 = 4'd5;
            else if (val >= 40) to_bcd_tens_0_5 = 4'd4;
            else if (val >= 30) to_bcd_tens_0_5 = 4'd3;
            else if (val >= 20) to_bcd_tens_0_5 = 4'd2;
            else if (val >= 10) to_bcd_tens_0_5 = 4'd1;
            else to_bcd_tens_0_5 = 4'd0;
        end
    endfunction

    // Combinational BCD conversion for seconds and minutes
    reg [3:0] ss_tens, ss_units;
    reg [3:0] mm_tens, mm_units;

    always @(*) begin
        ss_tens = to_bcd_tens_0_5(seconds);
        ss_units = seconds - (ss_tens * 10);
        mm_tens = to_bcd_tens_0_5(minutes);
        mm_units = minutes - (mm_tens * 10);
    end

    // Combinational BCD conversion for hours (1-12)
    reg [3:0] hh_tens, hh_units;
    always @(*) begin
        if (hours >= 10) begin
            hh_tens = 4'd1;
            hh_units = hours - 4'd10;
        end else begin
            hh_tens = 4'd0;
            hh_units = hours;
        end
    end

    // Register BCD outputs synchronously to improve timing
    always @(posedge clk) begin
        if (reset) begin
            ss <= 8'd0;
            mm <= 8'd0;
            hh <= 8'd0;
        end else begin
            ss <= {ss_tens, ss_units};
            mm <= {mm_tens, mm_units};
            hh <= {hh_tens, hh_units};
        end
    end

endmodule