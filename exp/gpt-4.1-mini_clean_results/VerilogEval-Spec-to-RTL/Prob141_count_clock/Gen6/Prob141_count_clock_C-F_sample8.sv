module TopModule(
    input  wire       clk,
    input  wire       reset,
    input  wire       ena,
    output reg        pm,
    output reg [7:0]  hh,
    output reg [7:0]  mm,
    output reg [7:0]  ss
);

    // Binary counters for time
    reg [5:0] seconds;  // 0 to 59
    reg [5:0] minutes;  // 0 to 59
    reg [3:0] hours;    // 1 to 12 (binary)

    // Registered BCD outputs to reduce toggling
    reg [7:0] bcd_hh;
    reg [7:0] bcd_mm;
    reg [7:0] bcd_ss;

    // Function to convert binary 0-59 to BCD without multiplication:
    // Use subtractive method with minimal steps to find tens digit (0-5)
    function [7:0] bin_to_bcd_0_59;
        input [5:0] val;
        reg [3:0] tens;
        reg [3:0] ones;
        reg [6:0] temp;
        begin
            // Subtract 50 if possible
            if (val >= 50) begin
                tens = 5;
                ones = val - 50;
            end else if (val >= 40) begin
                tens = 4;
                ones = val - 40;
            end else if (val >= 30) begin
                tens = 3;
                ones = val - 30;
            end else if (val >= 20) begin
                tens = 2;
                ones = val - 20;
            end else if (val >= 10) begin
                tens = 1;
                ones = val - 10;
            end else begin
                tens = 0;
                ones = val;
            end
            bin_to_bcd_0_59 = {tens, ones};
        end
    endfunction

    // Function to convert binary hour (1-12) to BCD:
    // Since hour is from 1 to 12, tens digit is 0 or 1 only
    function [7:0] bin_to_bcd_hour;
        input [3:0] val;
        reg [3:0] tens;
        reg [3:0] ones;
        begin
            if (val >= 10) begin
                tens = 4'd1;
                ones = val - 4'd10;
            end else begin
                tens = 4'd0;
                ones = val;
            end
            bin_to_bcd_hour = {tens, ones};
        end
    endfunction

    // Synchronous logic: counters, pm toggle, and BCD register update
    always @(posedge clk) begin
        if (reset) begin
            pm      <= 1'b0;      // AM
            seconds <= 6'd0;
            minutes <= 6'd0;
            hours   <= 4'd12;
            // Update outputs on reset as well
            bcd_ss  <= bin_to_bcd_0_59(6'd0);
            bcd_mm  <= bin_to_bcd_0_59(6'd0);
            bcd_hh  <= bin_to_bcd_hour(4'd12);
        end else if (ena) begin
            // Increment seconds
            if (seconds == 6'd59) begin
                seconds <= 6'd0;
                // Increment minutes
                if (minutes == 6'd59) begin
                    minutes <= 6'd0;
                    // Increment hours (1-12)
                    if (hours == 4'd11) begin
                        hours <= 4'd12;
                        pm <= ~pm; // toggle pm at 11->12
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

            // Update BCD outputs only on increments to reduce toggling
            bcd_ss <= bin_to_bcd_0_59(
                (seconds == 6'd59) ? 6'd0 : (seconds + 1)
            );
            bcd_mm <= bin_to_bcd_0_59(
                (seconds == 6'd59 && minutes == 6'd59) ? 6'd0 :
                (seconds == 6'd59) ? (minutes + 1) : minutes
            );
            bcd_hh <= bin_to_bcd_hour(
                (seconds == 6'd59 && minutes == 6'd59) ?
                    (
                        (hours == 4'd11) ? 4'd12 :
                        (hours == 4'd12) ? 4'd1 :
                        (hours + 1)
                    )
                : hours
            );
        end
    end

    // Outputs assigned from registered BCD to ensure stable outputs
    always @(*) begin
        ss = bcd_ss;
        mm = bcd_mm;
        hh = bcd_hh;
    end

endmodule