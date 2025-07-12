module TopModule (
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

reg [31:0] total_seconds; // Counter for total seconds

always @(posedge clk) begin
    if (reset) begin
        total_seconds <= 0;
    end else if (ena) begin
        if (total_seconds == 43200) begin // 12 hours in seconds
            total_seconds <= 0;
        end else begin
            total_seconds <= total_seconds + 1;
        end
    end
end

// Convert total seconds to hours, minutes, and seconds
reg [3:0] hours_12; // 0-11 for 12-hour format
reg [5:0] minutes;
reg [5:0] seconds;

always @(posedge clk) begin
    reg [31:0] temp_total_seconds;
    temp_total_seconds = total_seconds;
    
    hours_12 = (temp_total_seconds / 3600) % 12; // Calculate hours in 12-hour format
    minutes = (temp_total_seconds / 60) % 60; // Calculate minutes
    seconds = temp_total_seconds % 60; // Calculate seconds
end

// Convert binary to BCD
function [7:0] binary_to_bcd;
    input [5:0] binary;
    reg [3:0] tens;
    reg [3:0] ones;
    tens = binary / 10;
    ones = binary % 10;
    binary_to_bcd = {4'b0000, tens, ones};
endfunction

// Assign outputs
assign pm = (total_seconds >= 43200 / 2) ? 1'b1 : 1'b0; // PM indicator
assign hh = (hours_12 == 0) ? {4'b0000, 4'd12} : binary_to_bcd({2'b0, hours_12}); // Convert hours to BCD
assign mm = binary_to_bcd(minutes); // Convert minutes to BCD
assign ss = binary_to_bcd(seconds); // Convert seconds to BCD

endmodule