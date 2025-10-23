module TopModule(
    input  wire       clk,
    input  wire       reset,
    input  wire       ena,
    output reg        pm,
    output reg [7:0]  hh,
    output reg [7:0]  mm,
    output reg [7:0]  ss
);

    // Binary counters for seconds (0-59), minutes (0-59), and hours (1-12)
    reg [5:0] sec_bin;   // 6 bits for 0-59
    reg [5:0] min_bin;   // 6 bits for 0-59
    reg [3:0] hour_bin;  // 4 bits for 1-12

    // Convert 0-59 binary to BCD
    function [7:0] bin60_to_bcd(input [5:0] val);
        reg [3:0] tens;
        reg [3:0] units;
        begin
            tens  = val / 6'd10;
            units = val % 6'd10;
            bin60_to_bcd = {tens, units};
        end
    endfunction

    // Convert hour binary (1..12) to BCD (same as original)
    function [7:0] bin_to_bcd_hour(input [3:0] bin_hour);
        begin
            if (bin_hour <= 4'd9)
                bin_to_bcd_hour = {4'd0, bin_hour};          // tens=0
            else
                bin_to_bcd_hour = {4'd1, bin_hour - 4'd10}; // tens=1
        end
    endfunction

    always @(posedge clk) begin
        if (reset) begin
            pm       <= 1'b0;
            hour_bin <= 4'd12;
            min_bin  <= 6'd0;
            sec_bin  <= 6'd0;
        end else if (ena) begin
            if (sec_bin == 6'd59) begin
                sec_bin <= 6'd0;
                if (min_bin == 6'd59) begin
                    min_bin <= 6'd0;
                    if (hour_bin == 4'd12) begin
                        hour_bin <= 4'd1;
                    end else begin
                        hour_bin <= hour_bin + 4'd1;
                    end
                    // Toggle PM when hour changes from 11 to 12
                    if (hour_bin == 4'd11)
                        pm <= ~pm;
                end else begin
                    min_bin <= min_bin + 6'd1;
                end
            end else begin
                sec_bin <= sec_bin + 6'd1;
            end
        end
    end

    always @* begin
        hh = bin_to_bcd_hour(hour_bin);
        mm = bin60_to_bcd(min_bin);
        ss = bin60_to_bcd(sec_bin);
    end

endmodule