module TopModule (
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

    // 17 bits can count up to 131,072 (need only 43,200 for 12 hours)
    reg [16:0] total_seconds;
    wire [16:0] next_seconds;
    reg pm_reg;

    // Total seconds calculation
    assign next_seconds = (total_seconds == 17'd43199) ? 17'd0 : (total_seconds + 1);

    always @(posedge clk) begin
        if (reset) begin
            total_seconds <= 17'd0;  // 12:00:00 AM = 0 seconds
            pm_reg <= 1'b0;
        end else if (ena) begin
            total_seconds <= next_seconds;
            // Toggle PM at noon (43,200/2 = 21,600 seconds)
            if (next_seconds == 17'd21600) pm_reg <= 1'b1;
            else if (next_seconds == 17'd0) pm_reg <= 1'b0;
        end
    end

    // Convert total seconds to time components
    wire [16:0] remaining_after_hours = total_seconds % 17'd3600;
    wire [4:0] hours = (total_seconds / 17'd3600) % 12;
    wire [5:0] minutes = remaining_after_hours / 17'd60;
    wire [5:0] seconds = remaining_after_hours % 17'd60;

    // Convert to BCD (using helper functions)
    function [7:0] bin2bcd;
        input [5:0] bin;
        reg [3:0] tens;
        reg [3:0] ones;
        begin
            tens = bin / 10;
            ones = bin % 10;
            bin2bcd = {tens, ones};
        end
    endfunction

    // Handle 12-hour conversion (0->12, 1->1, etc.)
    wire [4:0] display_hour = (hours == 0) ? 5'd12 : hours;
    
    assign hh = bin2bcd(display_hour);
    assign mm = bin2bcd(minutes);
    assign ss = bin2bcd(seconds);
    assign pm = pm_reg;

endmodule