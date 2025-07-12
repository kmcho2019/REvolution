module TopModule (
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

    // Convert 4-bit binary to BCD tens and units for hours (1 to 12)
    function [7:0] bin_to_bcd_hour;
        input [3:0] bin_hour;
        reg [3:0] tens, units;
        begin
            // Valid bin_hour range: 1 to 12
            if (bin_hour <= 4'd9) begin
                tens = 4'd0;
                units = bin_hour[3:0];
            end else begin
                tens = 4'd1;
                units = bin_hour - 4'd10;
            end
            bin_to_bcd_hour = {tens, units};
        end
    endfunction

    // BCD increment for seconds or minutes (0-59)
    // Returns incremented value and rollover flag
    function [8:0] bcd_inc_59;
        input [7:0] val;
        reg [3:0] tens, units;
        reg rollover;
        begin
            tens = val[7:4];
            units = val[3:0];
            if (units == 4'd9) begin
                units = 4'd0;
                if (tens == 4'd5) begin
                    tens = 4'd0;
                    rollover = 1'b1;
                end else begin
                    tens = tens + 4'd1;
                    rollover = 1'b0;
                end
            end else begin
                units = units + 4'd1;
                rollover = 1'b0;
            end
            bcd_inc_59 = {rollover, tens, units}; // [8] = rollover flag
        end
    endfunction

    // Internal hour counter in binary (1 to 12)
    reg [3:0] hour_bin;

    always @(posedge clk) begin
        if (reset) begin
            pm <= 1'b0;    // AM
            hour_bin <= 4'd12; // 12
            mm <= 8'h00;
            ss <= 8'h00;
            hh <= bin_to_bcd_hour(4'd12);
        end else if (ena) begin
            // Increment seconds
            reg [8:0] sec_inc;
            sec_inc = bcd_inc_59(ss);
            ss <= sec_inc[7:0];

            if (sec_inc[8]) begin  // seconds rolled over
                reg [8:0] min_inc;
                min_inc = bcd_inc_59(mm);
                mm <= min_inc[7:0];

                if (min_inc[8]) begin // minutes rolled over
                    // increment hour binary counter
                    if (hour_bin == 4'd11) begin
                        pm <= ~pm;  // Toggle pm at 11->12
                        hour_bin <= 4'd12;
                    end else if (hour_bin == 4'd12) begin
                        hour_bin <= 4'd1;
                    end else begin
                        hour_bin <= hour_bin + 4'd1;
                    end
                    // Convert binary hour to BCD for output
                    hh <= bin_to_bcd_hour(hour_bin);
                end
            end
        end
    end

endmodule