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
        hours_count <= 1; // Reset to 12:00 AM
        pm <= 1'b0; // AM
    end else if (ena) begin
        if (seconds_count == 59) begin
            seconds_count <= 0;
            if (minutes_count == 59) begin
                minutes_count <= 0;
                if (hours_count == 12) begin
                    hours_count <= 1; // Wrap around to 1 (1:00 AM)
                    pm <= 1'b0; // AM
                end else if (hours_count == 11) begin
                    hours_count <= 12; // Switch to PM
                    pm <= 1'b1; // PM
                end else begin
                    hours_count <= hours_count + 1;
                end
            end else begin
                minutes_count <= minutes_count + 1;
            end
        end else begin
            seconds_count <= seconds_count + 1;
        end
    end
end

always @(posedge clk) begin
    // Update pm signal based on hours_count
    if (hours_count >= 12) begin
        pm <= 1'b1; // PM
    end else begin
        pm <= 1'b0; // AM
    end

    // Convert hours, minutes, and seconds to BCD
    if (hours_count == 12) begin
        hh <= {4'd1, 2'd0}; // 12:00
    end else begin
        hh <= {4'd0, hours_count}; // Ensure hours are always in BCD format
    end
    mm <= {4'd0, minutes_count / 10, minutes_count % 10};
    ss <= {4'd0, seconds_count / 10, seconds_count % 10};
end

endmodule