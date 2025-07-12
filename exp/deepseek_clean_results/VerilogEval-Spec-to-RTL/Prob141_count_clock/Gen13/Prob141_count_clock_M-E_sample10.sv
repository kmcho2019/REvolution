module TopModule (
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

    // Unified seconds counter (0-43199 for 12 hours)
    reg [16:0] total_seconds;
    wire [16:0] next_seconds = (total_seconds == 17'd43199) ? 17'd0 : total_seconds + 1;

    always @(posedge clk) begin
        if (reset) begin
            total_seconds <= 17'd0;
        end else if (ena) begin
            total_seconds <= next_seconds;
        end
    end

    // Time extraction (combinational)
    wire [16:0] seconds_in_day = total_seconds;
    wire [15:0] seconds_in_half_day = seconds_in_day - 17'd21600;
    
    // PM indicator (second half of 12-hour cycle)
    assign pm = (seconds_in_day >= 17'd21600);

    // Calculate hours (1-12)
    wire [16:0] hour_seconds = pm ? seconds_in_half_day : seconds_in_day;
    wire [7:0] hour_bcd = (hour_seconds / 17'd3600) + 1; // 1-12
    wire [3:0] hour_tens = (hour_bcd > 8'd9) ? 4'd1 : 4'd0;
    wire [3:0] hour_ones = (hour_bcd > 8'd9) ? hour_bcd[3:0] - 4'd10 : hour_bcd[3:0];

    // Calculate minutes (00-59)
    wire [16:0] remaining_after_hours = hour_seconds % 17'd3600;
    wire [7:0] minute_bcd = remaining_after_hours / 17'd60;
    wire [3:0] minute_tens = minute_bcd[7:4];
    wire [3:0] minute_ones = minute_bcd[3:0];

    // Calculate seconds (00-59)
    wire [7:0] second_bcd = remaining_after_hours % 17'd60;
    wire [3:0] second_tens = second_bcd[7:4];
    wire [3:0] second_ones = second_bcd[3:0];

    // Output assignments
    assign hh = {hour_tens, hour_ones};
    assign mm = {minute_tens, minute_ones};
    assign ss = {second_tens, second_ones};

endmodule