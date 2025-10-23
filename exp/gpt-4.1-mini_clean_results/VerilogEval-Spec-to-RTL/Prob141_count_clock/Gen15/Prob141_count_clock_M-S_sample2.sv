module TopModule(
    input  wire       clk,
    input  wire       reset,
    input  wire       ena,
    output reg        pm,
    output reg [7:0]  hh,
    output reg [7:0]  mm,
    output reg [7:0]  ss
);

    reg [7:0] sec_bcd;  // 00 to 59 in BCD: upper nibble tens, lower nibble units
    reg [7:0] min_bcd;  // 00 to 59 in BCD
    reg [3:0] hour_bin; // 1 to 12 binary hours

    // Increment a BCD value representing 00-59, return carry out if rolling over
    function automatic [1:0] bcd_inc_59;
        input [7:0] bcd_in;
        reg [3:0] units;
        reg [3:0] tens;
        begin
            units = bcd_in[3:0];
            tens  = bcd_in[7:4];
            if (units == 4'd9) begin
                units = 4'd0;
                if (tens == 4'd5) begin
                    tens = 4'd0;
                    bcd_inc_59[1] = 1'b1; // rollover carry
                end else begin
                    tens = tens + 1;
                    bcd_inc_59[1] = 1'b0;
                end
            end else begin
                units = units + 1;
                bcd_inc_59[1] = 1'b0;
            end
            bcd_inc_59[0] = {tens, units};
        end
    endfunction

    // Convert binary hour (1-12) to BCD
    function [7:0] bin_to_bcd_hour;
        input [3:0] hour;
        begin
            if (hour >= 10)
                bin_to_bcd_hour = {4'd1, hour - 4'd10};
            else
                bin_to_bcd_hour = {4'd0, hour};
        end
    endfunction

    always @(posedge clk) begin
        if (reset) begin
            pm <= 1'b0; // AM
            sec_bcd <= 8'h00;
            min_bcd <= 8'h00;
            hour_bin <= 4'd12;
        end else if (ena) begin
            // Increment seconds
            reg carry_sec;
            reg [7:0] next_sec;
            {carry_sec, next_sec} = bcd_inc_59(sec_bcd);

            sec_bcd <= next_sec;

            if (carry_sec) begin
                // Increment minutes
                reg carry_min;
                reg [7:0] next_min;
                {carry_min, next_min} = bcd_inc_59(min_bcd);

                min_bcd <= next_min;

                if (carry_min) begin
                    // Increment hours
                    if (hour_bin == 4'd11) begin
                        hour_bin <= 4'd12;
                        pm <= ~pm; // toggle pm at 12
                    end else if (hour_bin == 4'd12) begin
                        hour_bin <= 4'd1;
                    end else begin
                        hour_bin <= hour_bin + 1;
                    end
                end
            end
        end
    end

    always @* begin
        hh = bin_to_bcd_hour(hour_bin);
        mm = min_bcd;
        ss = sec_bcd;
    end

endmodule