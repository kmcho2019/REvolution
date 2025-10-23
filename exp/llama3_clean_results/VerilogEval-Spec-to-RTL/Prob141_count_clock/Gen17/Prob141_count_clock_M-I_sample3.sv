module TopModule(
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

reg [3:0] hours_tens;
reg [3:0] hours_ones;
reg [3:0] minutes_tens;
reg [3:0] minutes_ones;
reg [3:0] seconds_tens;
reg [3:0] seconds_ones;

reg [5:0] seconds_count;
reg [5:0] minutes_count;
reg [4:0] hours_count;

always @(posedge clk) begin
    if (reset) begin
        seconds_count <= 0;
        minutes_count <= 0;
        hours_count <= 0;
        pm <= 1'b0; // Reset to AM
    end else if (ena) begin
        // Increment seconds
        if (seconds_count == 59) begin
            seconds_count <= 0;
            // Increment minutes
            if (minutes_count == 59) begin
                minutes_count <= 0;
                // Increment hours
                if (hours_count == 11) begin
                    hours_count <= 0; // Wrap around to 12:00 AM
                    pm <= 1'b0; // AM
                end else if (hours_count == 12) begin // This handles the wrap from 12 to 1
                    hours_count <= 1;
                    pm <= 1'b1; // PM
                end else if (hours_count < 12) begin
                    hours_count <= hours_count + 1;
                    pm <= 1'b0; // AM
                end else begin
                    hours_count <= hours_count + 1;
                    pm <= 1'b1; // PM
                end
            end else begin
                minutes_count <= minutes_count + 1;
            end
        end else begin
            seconds_count <= seconds_count + 1;
        end
    end

    // Convert hours, minutes, and seconds to BCD
    hours_tens = hours_count / 10;
    hours_ones = hours_count % 10;
    minutes_tens = minutes_count / 10;
    minutes_ones = minutes_count % 10;
    seconds_tens = seconds_count / 10;
    seconds_ones = seconds_count % 10;

    // Assign BCD values to outputs, padding with zeros if necessary
    hh <= {hours_tens, hours_ones};
    mm <= {minutes_tens, minutes_ones};
    ss <= {seconds_tens, seconds_ones};
end

endmodule