module TopModule(
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

// Declare internal signals for hours, minutes, and seconds counters
reg [3:0] hours_tens;
reg [3:0] hours_ones;
reg [5:0] minutes_tens;
reg [5:0] minutes_ones;
reg [5:0] seconds_tens;
reg [5:0] seconds_ones;

// Initialize pm output based on hours counter
assign pm = (hours_tens == 4'd1) ? 1'b1 : 1'b0;

// Assign BCD outputs for hours, minutes, and seconds
assign hh = {hours_tens, hours_ones};
assign mm = {minutes_tens, minutes_ones};
assign ss = {seconds_tens, seconds_ones};

// Define a parameter for one second in clock cycles
parameter CLOCK_CYCLES_PER_SECOND = 100000000; // Example value, adjust according to your clock frequency

// Counter for clock cycles per second
reg [31:0] clock_cycle_counter;

always @(posedge clk) begin
    // Reset logic
    if (reset) begin
        hours_tens <= 4'd0;
        hours_ones <= 4'd1;
        minutes_tens <= 4'd0;
        minutes_ones <= 4'd0;
        seconds_tens <= 4'd0;
        seconds_ones <= 4'd0;
        clock_cycle_counter <= 32'd0;
    end else if (ena && (clock_cycle_counter == CLOCK_CYCLES_PER_SECOND - 1)) begin
        // Increment seconds counter
        if (seconds_ones == 4'd9) begin
            seconds_ones <= 4'd0;
            if (seconds_tens == 4'd5) begin
                seconds_tens <= 4'd0;
                // Increment minutes counter
                if (minutes_ones == 4'd9) begin
                    minutes_ones <= 4'd0;
                    if (minutes_tens == 4'd5) begin
                        minutes_tens <= 4'd0;
                        // Increment hours counter
                        if (hours_ones == 4'd2 && hours_tens == 4'd1) begin
                            hours_tens <= 4'd0;
                            hours_ones <= 4'd1;
                        end else if (hours_ones == 4'd9) begin
                            hours_ones <= 4'd0;
                            hours_tens <= hours_tens + 1;
                        end else begin
                            hours_ones <= hours_ones + 1;
                        end
                    end else begin
                        minutes_tens <= minutes_tens + 1;
                    end
                end else begin
                    minutes_ones <= minutes_ones + 1;
                end
            end else begin
                seconds_tens <= seconds_tens + 1;
            end
        end else begin
            seconds_ones <= seconds_ones + 1;
        end
        clock_cycle_counter <= 32'd0;
    end else if (ena) begin
        clock_cycle_counter <= clock_cycle_counter + 1;
    end
end

endmodule