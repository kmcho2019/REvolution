module TopModule (
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

    // 17-bit counter (0 to 43199 for 12 hours)
    reg [16:0] total_seconds;
    wire [16:0] next_total_seconds = (total_seconds == 17'd43199) ? 17'd0 : total_seconds + 17'd1;

    always @(posedge clk) begin
        if (reset) begin
            total_seconds <= 17'd0;  // 12:00:00 AM
        end else if (ena) begin
            total_seconds <= next_total_seconds;
        end
    end

    // PM indicator (second half of 12-hour cycle)
    assign pm = (total_seconds >= 17'd21600);  // 6:00:00 AM to 5:59:59 PM

    // Time extraction functions
    function [7:0] get_seconds;
        input [16:0] ts;
        reg [5:0] sec;
        reg [3:0] ones, tens;
        begin
            sec = ts % 6'd60;
            ones = sec % 4'd10;
            tens = sec / 4'd10;
            get_seconds = {tens, ones};
        end
    endfunction

    function [7:0] get_minutes;
        input [16:0] ts;
        reg [5:0] min;
        reg [3:0] ones, tens;
        begin
            min = (ts / 6'd60) % 6'd60;
            ones = min % 4'd10;
            tens = min / 4'd10;
            get_minutes = {tens, ones};
        end
    endfunction

    function [7:0] get_hours;
        input [16:0] ts;
        reg [4:0] hr;
        reg [3:0] ones, tens;
        begin
            hr = (ts / 7'd3600);
            if (hr == 5'd0) hr = 5'd12;  // Convert 0 to 12
            ones = hr % 4'd10;
            tens = hr / 4'd10;
            get_hours = {tens, ones};
        end
    endfunction

    // Output assignments
    assign ss = get_seconds(total_seconds);
    assign mm = get_minutes(total_seconds);
    assign hh = get_hours(total_seconds);

endmodule