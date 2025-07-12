module TopModule(
    input  wire       clk,
    input  wire       reset,
    input  wire       ena,
    output reg        pm,
    output reg [7:0]  hh,
    output reg [7:0]  mm,
    output reg [7:0]  ss
);

// Registers: each BCD digit 4-bit
reg [3:0] ss_units, ss_tens;
reg [3:0] mm_units, mm_tens;
reg [3:0] hh_units, hh_tens; // hours in BCD 01-12

// Helper function: increment BCD digit with max limit, returns (new_digit, carry)
function automatic [4:0] bcd_inc_limit(input [3:0] digit, input [3:0] max);
    reg [4:0] sum;
    begin
        if (digit == max)
            sum = {1'b1, 4'd0}; // carry=1, digit=0
        else
            sum = {1'b0, digit + 4'd1};
        bcd_inc_limit = sum;
    end
endfunction

always @(posedge clk) begin
    if (reset) begin
        // Reset to 12:00:00 AM
        ss_units <= 4'd0;
        ss_tens  <= 4'd0;
        mm_units <= 4'd0;
        mm_tens  <= 4'd0;
        hh_units <= 4'd2; // 12 hours: tens=1, units=2 but since 12 is two digits
        hh_tens  <= 4'd1;
        pm       <= 1'b0; // AM
    end else if (ena) begin
        // Seconds increment
        if (ss_units == 4'd9) begin
            ss_units <= 4'd0;
            if (ss_tens == 4'd5) begin
                ss_tens <= 4'd0;

                // Minutes increment
                if (mm_units == 4'd9) begin
                    mm_units <= 4'd0;
                    if (mm_tens == 4'd5) begin
                        mm_tens <= 4'd0;

                        // Hours increment
                        if (hh_units == 4'd9) begin
                            // hh_units roll over from 9 to 0, must fix hour tens & units carefully
                            if (hh_tens == 4'd0) begin
                                // Hours go from 09 to 10
                                hh_units <= 4'd0;
                                hh_tens <= 4'd1;
                            end else if (hh_tens == 4'd1) begin
                                if (hh_units == 4'd2) begin
                                    // From 12 to 1
                                    hh_units <= 4'd1;
                                    hh_tens <= 4'd0;
                                    pm <= ~pm; // toggle pm at rollover 12->1
                                end else begin
                                    // Should not happen: 1x other than 12 not allowed
                                    hh_units <= hh_units; 
                                    hh_tens <= hh_tens;
                                end
                            end else begin
                                hh_units <= hh_units;
                                hh_tens <= hh_tens;
                            end
                        end else begin
                            // Hours units increment (1..9)
                            if (hh_tens == 4'd0) begin
                                // 01..09
                                if (hh_units == 4'd9) begin
                                    // 09 -> 10
                                    hh_units <= 4'd0;
                                    hh_tens <= 4'd1;
                                end else begin
                                    hh_units <= hh_units + 4'd1;
                                end
                            end else if (hh_tens == 4'd1) begin
                                // 10..12
                                if (hh_units == 4'd2) begin
                                    // 12 -> 1
                                    hh_units <= 4'd1;
                                    hh_tens <= 4'd0;
                                    pm <= ~pm; // toggle pm
                                end else begin
                                    hh_units <= hh_units + 4'd1;
                                end
                            end else begin
                                // Should not happen
                                hh_units <= hh_units;
                                hh_tens <= hh_tens;
                            end
                        end

                    end else begin
                        mm_tens <= mm_tens + 4'd1;
                    end
                end else begin
                    mm_units <= mm_units + 4'd1;
                end

            end else begin
                ss_tens <= ss_tens + 4'd1;
            end
        end else begin
            ss_units <= ss_units + 4'd1;
        end
    end
end

// Output concatenation
always @(*) begin
    hh = {hh_tens, hh_units};
    mm = {mm_tens, mm_units};
    ss = {ss_tens, ss_units};
end

endmodule