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
        // Reset all counters and signals
        seconds_count <= 6'd0;
        minutes_count <= 6'd0;
        hours_count <= 4'd1; // 12:00 AM
        pm <= 1'b0;
    end else if (ena) begin
        // Increment seconds
        if (seconds_count == 6'd59) begin
            seconds_count <= 6'd0;
            // Increment minutes
            if (minutes_count == 6'd59) begin
                minutes_count <= 6'd0;
                // Increment hours, handling wrap-around and AM/PM
                if (hours_count == 4'd12) begin
                    hours_count <= 4'd1; // Wrap to 1:00 AM
                    pm <= 1'b0; // AM
                end else if (hours_count == 4'd11 && pm == 1'b1) begin
                    hours_count <= 4'd12; // PM
                    pm <= 1'b1;
                end else begin
                    hours_count <= hours_count + 1;
                    // Switch AM/PM at noon and midnight
                    if (hours_count == 4'd12) begin
                        pm <= 1'b1; // PM
                    end else if (hours_count == 4'd1) begin
                        pm <= 1'b0; // AM
                    end
                end
            end else begin
                minutes_count <= minutes_count + 1;
            end
        end else begin
            seconds_count <= seconds_count + 1;
        end
    end
end

always @(*) begin
    // BCD conversion for hh, mm, ss
    hh <= {4'd1, hours_count[3:0] % 10}; // Assuming hours_count is always < 10 for BCD
    mm <= {(minutes_count[5:4] * 10) + minutes_count[3:0]};
    ss <= {(seconds_count[5:4] * 10) + seconds_count[3:0]};
end

endmodule