module TopModule(
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

reg [1:0] state; // FSM states: 2'b00 - S_RESET, 2'b01 - S_COUNTING, 2'b10 - S_WRAP_HOURS
reg [5:0] seconds_count;
reg [5:0] minutes_count;
reg [3:0] hours_count;

always @(posedge clk) begin
    case(state)
        2'b00: // S_RESET
            if (~reset) begin
                state <= 2'b01;
                seconds_count <= 0;
                minutes_count <= 0;
                hours_count <= 1; // Reset to 12:00 AM
                pm <= 1'b0; // AM
            end
        2'b01: // S_COUNTING
            if (reset) begin
                state <= 2'b00;
            end else if (ena) begin
                if (seconds_count == 59) begin
                    seconds_count <= 0;
                    if (minutes_count == 59) begin
                        minutes_count <= 0;
                        if (hours_count == 12) begin
                            state <= 2'b10; // Transition to wrap hours
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
        2'b10: // S_WRAP_HOURS
            if (reset) begin
                state <= 2'b00;
            end else begin
                hours_count <= 1; // Wrap around to 1 (1:00 AM)
                pm <= 1'b0; // AM
                state <= 2'b01; // Transition back to counting
            end
    endcase
end

always @(posedge clk) begin
    if (hours_count > 12) begin
        hours_count <= 1; // Ensure hours_count stays within 1-12 range for AM/PM logic
    end
    
    // Update pm signal based on hours_count
    if (hours_count >= 12) begin
        pm <= 1'b1; // PM
    end else begin
        pm <= 1'b0; // AM
    end

    // Convert hours, minutes, and seconds to BCD
    hh <= {4'd1, hours_count % 10}; // Ensure hours are always in BCD format
    mm <= {(minutes_count / 10) % 10, minutes_count % 10};
    ss <= {(seconds_count / 10) % 10, seconds_count % 10};
end

endmodule