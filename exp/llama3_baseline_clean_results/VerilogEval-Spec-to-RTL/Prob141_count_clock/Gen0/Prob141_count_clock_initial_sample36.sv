module TopModule(
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

// Initialize counters
reg [3:0] seconds;
reg [3:0] minutes;
reg [3:0] hours;

// Initialize BCD counters
reg [3:0] ss_ones;
reg [3:0] ss_tens;
reg [3:0] mm_ones;
reg [3:0] mm_tens;
reg [3:0] hh_ones;
reg [3:0] hh_tens;

always @(posedge clk) begin
    if (reset) begin
        // Reset counters
        seconds <= 0;
        minutes <= 0;
        hours <= 0;
        pm <= 0;
    end else if (ena) begin
        // Increment seconds counter
        seconds <= seconds + 1;

        if (seconds == 60) begin
            // Reset seconds counter and increment minutes counter
            seconds <= 0;
            minutes <= minutes + 1;

            if (minutes == 60) begin
                // Reset minutes counter and increment hours counter
                minutes <= 0;
                hours <= hours + 1;

                if (hours == 12) begin
                    // Reset hours counter
                    hours <= 0;
                    pm <= ~pm;  // Toggle AM/PM
                end
            end
        end
    end
end

always @(posedge clk) begin
    if (reset) begin
        // Reset BCD counters
        ss_ones <= 0;
        ss_tens <= 0;
        mm_ones <= 0;
        mm_tens <= 0;
        hh_ones <= 0;
        hh_tens <= 0;
    end else begin
        // Update BCD counters
        ss_ones <= seconds % 10;
        ss_tens <= seconds / 10;
        mm_ones <= minutes % 10;
        mm_tens <= minutes / 10;
        hh_ones <= hours % 10;
        hh_tens <= hours / 10;
    end
end

always @(*) begin
    // Assign BCD counters to output
    ss <= {ss_tens, ss_ones};
    mm <= {mm_tens, mm_ones};
    hh <= {hh_tens, hh_ones};
end

endmodule