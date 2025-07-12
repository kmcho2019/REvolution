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
    reg pm_reg;
    
    // State definitions
    localparam AM = 1'b0;
    localparam PM = 1'b1;
    
    // Total seconds increment
    always @(posedge clk) begin
        if (reset) begin
            total_seconds <= 0;
            pm_reg <= AM;
        end else if (ena) begin
            if (total_seconds == 43199) begin  // 11:59:59 PM
                total_seconds <= 0;
                pm_reg <= AM;
            end else begin
                total_seconds <= total_seconds + 1;
                // Toggle PM at noon (12:00:00)
                if (total_seconds == 21599)  // 11:59:59 AM
                    pm_reg <= PM;
            end
        end
    end
    
    // Time conversion functions
    function [7:0] get_seconds;
        input [31:0] ts;
        reg [5:0] sec;
        begin
            sec = ts % 60;
            get_seconds = {sec[5:4], sec[3:0]};  // Convert to BCD
        end
    endfunction
    
    function [7:0] get_minutes;
        input [31:0] ts;
        reg [5:0] min;
        begin
            min = (ts / 60) % 60;
            get_minutes = {min[5:4], min[3:0]};  // Convert to BCD
        end
    endfunction
    
    function [7:0] get_hours;
        input [31:0] ts;
        reg [4:0] hr;
        begin
            hr = (ts / 3600) % 12;
            hr = (hr == 0) ? 12 : hr;  // Convert 0 to 12
            get_hours = {1'b0, hr[4], hr[3:0]};  // Convert to BCD
        end
    endfunction
    
    // Output assignments
    assign ss = get_seconds(total_seconds);
    assign mm = get_minutes(total_seconds);
    assign hh = get_hours(total_seconds);
    assign pm = pm_reg;

endmodule