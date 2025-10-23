module TopModule (
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

    reg [31:0] total_seconds;
    wire [31:0] next_seconds = total_seconds + 1;
    
    // Time extraction
    wire [31:0] seconds_in_day = 12 * 60 * 60; // 12-hour cycle
    wire [31:0] current_seconds = total_seconds % seconds_in_day;
    
    // Break down time components
    wire [5:0] raw_sec = current_seconds % 60;
    wire [5:0] raw_min = (current_seconds / 60) % 60;
    wire [4:0] raw_hr = (current_seconds / 3600) % 12;
    wire is_pm = (current_seconds / 3600) >= 12;
    
    // Convert to BCD
    wire [7:0] sec_bcd = {raw_sec[5:4], raw_sec[3:0]};
    wire [7:0] min_bcd = {raw_min[5:4], raw_min[3:0]};
    
    // Special hour handling (12-hour format)
    wire [4:0] display_hr = (raw_hr == 0) ? 5'd12 : raw_hr;
    wire [7:0] hr_bcd = {display_hr[4], display_hr[3:0]};
    
    // Main counter
    always @(posedge clk) begin
        if (reset) begin
            total_seconds <= 0;
        end else if (ena) begin
            total_seconds <= next_seconds;
        end
    end
    
    // Output assignments
    assign ss = sec_bcd;
    assign mm = min_bcd;
    assign hh = hr_bcd;
    assign pm = is_pm;

endmodule