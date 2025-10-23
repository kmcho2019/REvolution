module TopModule(
    input  wire       clk,
    input  wire       reset,
    input  wire       ena,
    output reg        pm,
    output reg [7:0]  hh,
    output reg [7:0]  mm,
    output reg [7:0]  ss
);

// Internal binary counters for seconds (0-59), minutes (0-59), hours (1-12)
reg [5:0] seconds; // 0-59
reg [5:0] minutes; // 0-59
reg [3:0] hours;   // 1-12 (4 bits are enough for 12)

// Registers to hold BCD digits for outputs
reg [3:0] hh_tens, hh_units;
reg [3:0] mm_tens, mm_units;
reg [3:0] ss_tens, ss_units;

// Synchronous update of counters and PM with flattened logic
always @(posedge clk) begin
    if (reset) begin
        // Reset to 12:00:00 AM
        pm      <= 1'b0;
        seconds <= 6'd0;
        minutes <= 6'd0;
        hours   <= 4'd12;

        // Update BCD output registers on reset
        hh_tens  <= 4'd1;
        hh_units <= 4'd2;
        mm_tens  <= 4'd0;
        mm_units <= 4'd0;
        ss_tens  <= 4'd0;
        ss_units <= 4'd0;
    end else if (ena) begin
        // Increment seconds or reset and increment minutes/hours with flattened logic
        if (seconds == 6'd59) begin
            seconds <= 6'd0;
            if (minutes == 6'd59) begin
                minutes <= 6'd0;
                if (hours == 4'd11) begin
                    hours <= 4'd12;
                    pm <= ~pm; // Toggle PM at 11->12
                end else if (hours == 4'd12) begin
                    hours <= 4'd1;
                end else begin
                    hours <= hours + 4'd1;
                end
            end else begin
                minutes <= minutes + 6'd1;
            end
        end else begin
            seconds <= seconds + 6'd1;
        end

        // Update BCD outputs synchronously only when ena pulses (once per second)
        // Seconds conversion: tens = seconds - 10 if >=10 else 0
        if (seconds >= 6'd10) begin
            ss_tens  <= 4'd1;
            ss_units <= seconds - 6'd10;
        end else begin
            ss_tens  <= 4'd0;
            ss_units <= seconds[3:0];
        end

        // Minutes conversion similarly
        if (minutes >= 6'd10) begin
            mm_tens  <= 4'd1;
            mm_units <= minutes - 6'd10;
        end else begin
            mm_tens  <= 4'd0;
            mm_units <= minutes[3:0];
        end

        // Hours conversion (1 to 12)
        if (hours >= 4'd10) begin
            hh_tens  <= 4'd1;
            hh_units <= hours - 4'd10;
        end else begin
            hh_tens  <= 4'd0;
            hh_units <= hours;
        end
    end
end

// Output assignment from BCD registers (registered outputs)
always @(posedge clk) begin
    // After reset or ena, update outputs from stored digits and PM
    // Even if ena is low, hold last value
    hh <= {hh_tens, hh_units};
    mm <= {mm_tens, mm_units};
    ss <= {ss_tens, ss_units};
end

endmodule