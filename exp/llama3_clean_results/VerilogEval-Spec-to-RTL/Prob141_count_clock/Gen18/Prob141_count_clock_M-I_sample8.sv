module TopModule(
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

reg [5:0] seconds_count;
reg [5:0] minutes_count;
reg [3:0] hours_count;

always @(posedge clk) begin
    if (reset) begin
        seconds_count <= 0;
        minutes_count <= 0;
        hours_count <= 1; // Reset to 1 (12:00 AM)
        pm <= 1'b0; // Reset to AM
    end else if (ena) begin
        // Increment seconds
        if (seconds_count == 59) begin
            seconds_count <= 0;
            // Increment minutes
            if (minutes_count == 59) begin
                minutes_count <= 0;
                // Increment hours
                if (hours_count == 12) begin
                    hours_count <= 1; // Wrap around to 1 (1:00 AM)
                    pm <= 1'b0; // AM
                end else if (hours_count == 11) begin
                    hours_count <= 12; // 12:00 PM
                    pm <= 1'b1; // PM
                end else if (hours_count < 12 && pm == 1'b1) begin
                    hours_count <= hours_count + 1;
                    pm <= 1'b1; // PM
                end else begin
                    hours_count <= hours_count + 1;
                    pm <= 1'b0; // AM
                end
            end else begin
                minutes_count <= minutes_count + 1;
            end
        end else begin
            seconds_count <= seconds_count + 1;
        end
    end

    // Convert hours, minutes, and seconds to BCD
    hh <= {4'd1, hours_count}; // Ensure hours are always in BCD format with tens place as 1 for 12-hour clock
    mm <= {minutes_count / 10, minutes_count % 10};
    ss <= {seconds_count / 10, seconds_count % 10};
end

endmodule