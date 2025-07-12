module TopModule (
    input           clk,
    input           reset,
    input           ena,
    output          pm,
    output [7:0]    hh,
    output [7:0]    mm,
    output [7:0]    ss
);

// Define internal signals for hours, minutes, and seconds
reg [3:0] hours_int;
reg [5:0] minutes_int;
reg [5:0] seconds_int;

// Define the current pm status
reg pm_status;

// Define BCD output signals
reg [3:0] hh_tens;
reg [3:0] hh_ones;
reg [3:0] mm_tens;
reg [3:0] mm_ones;
reg [3:0] ss_tens;
reg [3:0] ss_ones;

// Always block for combinational logic
always @(*) begin
    // Map internal signals to BCD output signals
    hh_tens = hours_int / 10;
    hh_ones = hours_int % 10;
    mm_tens = minutes_int / 10;
    mm_ones = minutes_int % 10;
    ss_tens = seconds_int / 10;
    ss_ones = seconds_int % 10;
end

// Always block for sequential logic
always @(posedge clk) begin
    if (reset) begin
        // Reset all counters to their initial values
        hours_int <= 1;
        minutes_int <= 0;
        seconds_int <= 0;
        pm_status <= 0;
    end else if (ena) begin
        // Increment seconds counter
        if (seconds_int == 59) begin
            seconds_int <= 0;
            // Increment minutes counter
            if (minutes_int == 59) begin
                minutes_int <= 0;
                // Increment hours counter
                if (hours_int == 12) begin
                    hours_int <= 1;
                    pm_status <= ~pm_status; // Toggle pm status
                end else if (hours_int == 11) begin
                    hours_int <= 12;
                end else begin
                    hours_int <= hours_int + 1;
                end
            end else begin
                minutes_int <= minutes_int + 1;
            end
        end else begin
            seconds_int <= seconds_int + 1;
        end
    end
end

// Assign output signals
assign pm = pm_status;
assign hh = {hh_tens, hh_ones};
assign mm = {mm_tens, mm_ones};
assign ss = {ss_tens, ss_ones};

endmodule