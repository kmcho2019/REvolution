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
    wire [31:0] next_seconds;
    wire [5:0] raw_ss, raw_mm;
    wire [4:0] raw_hh;
    wire is_pm;
    
    // Total seconds counter
    always @(posedge clk) begin
        if (reset)
            total_seconds <= 0;
        else if (ena)
            total_seconds <= next_seconds;
    end
    
    // Next seconds calculation (mod 12 hours)
    assign next_seconds = (total_seconds == 43199) ? 0 : total_seconds + 1;
    
    // Time extraction
    assign raw_ss = total_seconds % 60;
    assign raw_mm = (total_seconds / 60) % 60;
    assign raw_hh = ((total_seconds / 3600) % 12) + 1;
    assign is_pm = (total_seconds >= 21600); // After 6 AM (6*3600 seconds)
    
    // BCD conversion functions
    function [7:0] to_bcd;
        input [5:0] value;
        begin
            to_bcd = {value[5:4], value[3:0]}; // Split into tens and units
            if (to_bcd[3:0] > 9) to_bcd[3:0] = to_bcd[3:0] - 10;
            if (to_bcd[7:4] > 9) to_bcd[7:4] = to_bcd[7:4] - 10;
        end
    endfunction
    
    function [7:0] hour_to_bcd;
        input [4:0] hour;
        begin
            hour_to_bcd = hour > 9 ? {4'h1, hour - 10} : {4'h0, hour};
        end
    endfunction
    
    // Output assignments
    assign pm = is_pm;
    assign ss = to_bcd(raw_ss);
    assign mm = to_bcd(raw_mm);
    assign hh = hour_to_bcd(raw_hh);

endmodule