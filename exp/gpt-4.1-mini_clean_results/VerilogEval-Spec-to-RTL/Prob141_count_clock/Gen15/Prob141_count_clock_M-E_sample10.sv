module TopModule(
    input  wire       clk,
    input  wire       reset,
    input  wire       ena,
    output reg        pm,
    output reg [7:0]  hh,
    output reg [7:0]  mm,
    output reg [7:0]  ss
);

    // Total seconds since 12:00 AM, range: 0 to 43199 (12 hours * 3600 seconds)
    reg [15:0] total_seconds; // 16 bits enough for 43200 max value

    // Function to convert binary number (0-59) to BCD (two digits)
    function [7:0] bin_to_bcd_60(input [7:0] bin_val);
        reg [3:0] tens;
        reg [3:0] units;
        begin
            tens  = bin_val / 10;
            units = bin_val % 10;
            bin_to_bcd_60 = {tens, units};
        end
    endfunction

    // Function to convert hour (1..12) to BCD
    function [7:0] hour_to_bcd(input [4:0] hour_val);
        reg [3:0] tens;
        reg [3:0] units;
        begin
            if (hour_val == 0)
                hour_val = 12;
            if (hour_val < 10) begin
                tens  = 4'd0;
                units = hour_val[3:0];
            end else begin
                tens  = 4'd1;
                units = hour_val - 4'd10;
            end
            hour_to_bcd = {tens, units};
        end
    endfunction

    // Sequential logic: increment total_seconds or reset
    always @(posedge clk) begin
        if (reset) begin
            total_seconds <= 16'd0;  // 12:00 AM start
        end else if (ena) begin
            if (total_seconds == 16'd43199) // max seconds in 12 hours - 1
                total_seconds <= 16'd0;
            else
                total_seconds <= total_seconds + 16'd1;
        end
    end

    // Combinational conversion of total_seconds to outputs
    always @* begin
        // Calculate hours, minutes, seconds
        // total_seconds range: 0..43199

        // Determine PM: true if total_seconds >= 21600 (12*3600/2)
        pm = (total_seconds >= 16'd21600);

        // Seconds part
        // seconds = total_seconds % 60
        ss = bin_to_bcd_60(total_seconds % 60);

        // Minutes part
        // minutes = (total_seconds / 60) % 60
        mm = bin_to_bcd_60((total_seconds / 60) % 60);

        // Hours part
        // hours = (total_seconds / 3600) % 12, but 0 means 12
        // So take remainder modulo 12 to get hour in 12-hour format
        hh = hour_to_bcd((total_seconds / 3600) % 12);
    end

endmodule