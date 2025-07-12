module TopModule (
    input        clk,
    input        reset,
    input        ena,
    output reg   pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

    // Internal registers
    reg [3:0] hour_bin;        // 1 to 12 binary hour
    reg [7:0] min_bcd;         // Minutes as two BCD digits: [7:4] tens, [3:0] ones
    reg [7:0] sec_bcd;         // Seconds as two BCD digits

    // BCD increment function: increments BCD value with limit (e.g. 59)
    // Returns {incremented_bcd, overflow}
    function automatic [8:0] bcd_increment_59;
        input [7:0] bcd_in;
        reg [3:0] tens;
        reg [3:0] ones;
        begin
            tens = bcd_in[7:4];
            ones = bcd_in[3:0];
            if (ones == 4'd9) begin
                ones = 4'd0;
                if (tens == 4'd5) begin
                    tens = 4'd0;
                    bcd_increment_59 = {8'd0, 1'b1}; // overflow
                end else begin
                    tens = tens + 4'd1;
                    bcd_increment_59 = {tens, ones, 1'b0};
                end
            end else begin
                ones = ones + 4'd1;
                bcd_increment_59 = {tens, ones, 1'b0};
            end
        end
    endfunction

    // Binary hour increment with wrap 1..12 and PM toggle indication
    // Returns {new_hour, pm_toggle}
    function automatic [5:0] hour_increment;
        input [3:0] hour_in;
        reg [3:0] hour_out;
        reg toggle_pm;
        begin
            toggle_pm = 1'b0;
            if (hour_in == 4'd11) begin
                hour_out = 4'd12;
                toggle_pm = 1'b1; // Toggle PM on 11->12 transition
            end else if (hour_in == 4'd12) begin
                hour_out = 4'd1;
                // no toggle here
            end else begin
                hour_out = hour_in + 4'd1;
            end
            hour_increment = {toggle_pm, hour_out};
        end
    endfunction

    // Binary to BCD hour conversion (1..12) to two digit BCD
    function [7:0] bin_to_bcd_hour;
        input [3:0] hour;
        begin
            if (hour < 10)
                bin_to_bcd_hour = {4'd0, hour};
            else
                bin_to_bcd_hour = {4'd1, hour - 4'd10};
        end
    endfunction

    // Registers updated only on ena or reset (gated enable)
    always @(posedge clk) begin
        if (reset) begin
            pm       <= 1'b0;       // AM
            hour_bin <= 4'd12;
            min_bcd  <= 8'd0;
            sec_bcd  <= 8'd0;
        end else if (ena) begin
            // Increment seconds BCD and check overflow
            // Use separate wires to avoid deep nesting
            reg [8:0] sec_inc_result;
            reg [8:0] min_inc_result;
            reg pm_toggle;
            reg [3:0] new_hour;

            sec_inc_result = bcd_increment_59(sec_bcd);

            if (sec_inc_result[0]) begin // overflow, increment minute
                min_inc_result = bcd_increment_59(min_bcd);
                if (min_inc_result[0]) begin // minute overflow, increment hour
                    {pm_toggle, new_hour} = hour_increment(hour_bin);
                    hour_bin <= new_hour;
                    pm <= pm ^ pm_toggle;
                    min_bcd <= min_inc_result[8:1];  // will be 00 after overflow
                end else begin
                    min_bcd <= min_inc_result[8:1];
                end
                sec_bcd <= 8'd0; // reset seconds on overflow
            end else begin
                sec_bcd <= sec_inc_result[8:1];
            end
        end
    end

    // Output registers to break combinational paths (registered outputs)
    always @(posedge clk) begin
        if (reset) begin
            hh <= 8'h12;   // 12
            mm <= 8'd0;
            ss <= 8'd0;
        end else begin
            hh <= bin_to_bcd_hour(hour_bin);
            mm <= min_bcd;
            ss <= sec_bcd;
        end
    end

endmodule