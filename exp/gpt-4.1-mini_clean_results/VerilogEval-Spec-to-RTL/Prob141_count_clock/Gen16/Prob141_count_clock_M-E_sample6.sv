module TopModule(
    input  wire       clk,
    input  wire       reset,
    input  wire       ena,
    output reg        pm,
    output reg [7:0]  hh,
    output reg [7:0]  mm,
    output reg [7:0]  ss
);

    // Internal binary time counters
    reg [5:0] sec_bin;   // 0-59
    reg [5:0] min_bin;   // 0-59
    reg [3:0] hour_bin;  // 1-12 (represented as 1 to 12, stored as 4-bit)

    // Increment time on ena pulse
    always @(posedge clk) begin
        if (reset) begin
            sec_bin  <= 6'd0;
            min_bin  <= 6'd0;
            hour_bin <= 4'd12;
            pm       <= 1'b0;   // AM
        end else if (ena) begin
            // Increment seconds
            if (sec_bin == 6'd59) begin
                sec_bin <= 6'd0;
                // Increment minutes
                if (min_bin == 6'd59) begin
                    min_bin <= 6'd0;
                    // Increment hours with PM toggle
                    if (hour_bin == 4'd11) begin
                        hour_bin <= 4'd12;
                        pm <= ~pm;
                    end else if (hour_bin == 4'd12) begin
                        hour_bin <= 4'd1;
                    end else begin
                        hour_bin <= hour_bin + 1;
                    end
                end else begin
                    min_bin <= min_bin + 1;
                end
            end else begin
                sec_bin <= sec_bin + 1;
            end
        end
    end

    // Double-dabble (shift-add-3) function for 8-bit BCD conversion
    function [7:0] bin2bcd8;
        input [7:0] bin_in;
        integer i;
        reg [11:0] shiftreg;
    begin
        shiftreg = 12'd0;
        shiftreg[7:0] = bin_in;
        for (i = 0; i < 8; i = i + 1) begin
            // Add 3 if BCD nibble >= 5 before shift
            if (shiftreg[11:8] >= 5)
                shiftreg[11:8] = shiftreg[11:8] + 3;
            if (shiftreg[7:4] >= 5)
                shiftreg[7:4] = shiftreg[7:4] + 3;
            if (shiftreg[3:0] >= 5)
                shiftreg[3:0] = shiftreg[3:0] + 3;
            shiftreg = shiftreg << 1;
        end
        // Return two BCD digits (tens and units)
        bin2bcd8 = {shiftreg[11:8], shiftreg[7:4]};
    end
    endfunction

    // Convert hour binary (1-12) to BCD using specialized logic:
    // Since hour_bin max is 12, this is simpler than generic bin2bcd8
    // For hours:
    // 1-9: tens=0, units=hour_bin
    // 10-12: tens=1, units=hour_bin-10
    always @* begin
        if (hour_bin > 9) begin
            hh = {4'd1, hour_bin - 4'd10};
        end else begin
            hh = {4'd0, hour_bin};
        end
    end

    // Convert binary minutes and seconds to BCD using double dabble function
    always @* begin
        mm = bin2bcd8(min_bin);
        ss = bin2bcd8(sec_bin);
    end

endmodule