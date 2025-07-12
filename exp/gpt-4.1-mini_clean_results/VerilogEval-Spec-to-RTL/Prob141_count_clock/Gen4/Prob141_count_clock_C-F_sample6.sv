module TopModule(
    input  wire       clk,
    input  wire       reset,
    input  wire       ena,
    output reg        pm,
    output reg [7:0]  hh,
    output reg [7:0]  mm,
    output reg [7:0]  ss
);

    // Internal binary counters for seconds (0-59), minutes (0-59)
    reg [5:0] seconds; // 0-59
    reg [5:0] minutes; // 0-59
    // Hour counter stored in BCD (01 to 12)
    reg [7:0] hour_bcd;

    // Increment BCD hour (01 to 12)
    // Using simple rules:
    // 01..08 -> increment units digit
    // 09 -> 10
    // 10 -> 11
    // 11 -> 12
    // 12 -> 01
    function [7:0] hour_bcd_inc(input [7:0] curr);
        reg [3:0] h_tens, h_units;
        begin
            h_tens  = curr[7:4];
            h_units = curr[3:0];
            case (curr)
                8'h12: hour_bcd_inc = 8'h01;
                8'h09:  hour_bcd_inc = 8'h10;
                8'h10:  hour_bcd_inc = 8'h11;
                8'h11:  hour_bcd_inc = 8'h12;
                default: begin
                    if (h_units == 4'd9) begin
                        h_tens = h_tens + 4'd1;
                        h_units = 4'd0;
                    end else begin
                        h_units = h_units + 4'd1;
                    end
                    hour_bcd_inc = {h_tens, h_units};
                end
            endcase
        end
    endfunction

    // Check if binary value is 59
    function is_59(input [5:0] val);
        begin
            is_59 = (val == 6'd59);
        end
    endfunction

    // Binary to BCD conversion for 0-59 (minutes and seconds)
    function [7:0] bin6_to_bcd8(input [5:0] bin6);
        reg [3:0] tens;
        reg [3:0] units;
        begin
            // Avoid division/mod by 10 to reduce logic:
            // Use repeated subtraction for 0-59 range
            tens = 4'd0;
            units = bin6;
            while (units >= 6'd10) begin
                units = units - 6'd10;
                tens = tens + 4'd1;
            end
            bin6_to_bcd8 = {tens, units};
        end
    endfunction

    // Detect hour rollover (from 11 to 12) to toggle PM
    wire hour_rollover = (hour_bcd == 8'h11);

    always @(posedge clk) begin
        if (reset) begin
            pm       <= 1'b0;    // AM
            seconds  <= 6'd0;
            minutes  <= 6'd0;
            hour_bcd <= 8'h12;   // 12
        end else if (ena) begin
            if (is_59(seconds)) begin
                seconds <= 6'd0;
                if (is_59(minutes)) begin
                    minutes <= 6'd0;
                    if (hour_rollover) begin
                        hour_bcd <= 8'h12;
                        pm <= ~pm;
                    end else if (hour_bcd == 8'h12) begin
                        hour_bcd <= 8'h01;
                    end else begin
                        hour_bcd <= hour_bcd_inc(hour_bcd);
                    end
                end else begin
                    minutes <= minutes + 6'd1;
                end
            end else begin
                seconds <= seconds + 6'd1;
            end
        end
    end

    // Drive outputs: hour is already BCD; minutes and seconds converted to BCD on output
    always @(*) begin
        hh = hour_bcd;
        mm = bin6_to_bcd8(minutes);
        ss = bin6_to_bcd8(seconds);
    end

endmodule