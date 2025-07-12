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
always @(posedge clk) begin
    if (reset) begin
        pm <= 0;
        hh <= {4'b0000, 4'd12};
        mm <= 8'b00000000;
        ss <= 8'b00000000;
    end else begin
        reg [3:0] hours_12; // 0-11 for 12-hour format
        reg [5:0] minutes;
        reg [5:0] seconds;

        hours_12 = (total_seconds / 3600) % 12; // Calculate hours in 12-hour format
        minutes = (total_seconds / 60) % 60; // Calculate minutes
        seconds = total_seconds % 60; // Calculate seconds

        pm <= (total_seconds >= 43200 / 2)? 1'b1 : 1'b0; // PM indicator
        hh <= (hours_12 == 0)? {4'b0000, 4'd12} : {4'b0000, {1'b0, hours_12}}; // Convert hours to BCD
        mm <= {4'b0000, minutes / 10, minutes % 10}; // Convert minutes to BCD
        ss <= {4'b0000, seconds / 10, seconds % 10}; // Convert seconds to BCD
    end
end

endmodule