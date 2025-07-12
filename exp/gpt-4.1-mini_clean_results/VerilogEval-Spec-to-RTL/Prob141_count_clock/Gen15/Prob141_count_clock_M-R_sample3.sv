module TopModule(
    input  wire       clk,
    input  wire       reset,
    input  wire       ena,
    output reg        pm,
    output reg [7:0]  hh,
    output reg [7:0]  mm,
    output reg [7:0]  ss
);

// Registers for BCD digits of seconds and minutes
reg [3:0] ss_units, ss_tens;
reg [3:0] mm_units, mm_tens;
// Registers for BCD digits of hour (01..12)
reg [3:0] hh_units, hh_tens;

always @(posedge clk) begin
    if (reset) begin
        // Reset time to 12:00:00 AM
        ss_units <= 4'd0;
        ss_tens  <= 4'd0;
        mm_units <= 4'd0;
        mm_tens  <= 4'd0;
        hh_units <= 4'd2;  // 12 hours: tens = 1 or 0? For 12, tens=1, units=2
        hh_tens  <= 4'd1;
        pm       <= 1'b0;  // AM
    end else if (ena) begin
        // Increment seconds
        if (ss_units == 4'd9) begin
            ss_units <= 4'd0;
            if (ss_tens == 4'd5) begin
                ss_tens <= 4'd0;
                // Increment minutes on second rollover
                if (mm_units == 4'd9) begin
                    mm_units <= 4'd0;
                    if (mm_tens == 4'd5) begin
                        mm_tens <= 4'd0;
                        // Increment hour on minute rollover
                        // Hours range 01..12 in BCD
                        if ((hh_tens == 4'd1 && hh_units == 4'd2)) begin
                            // If hour == 12, roll over to 01 and toggle pm
                            hh_tens <= 4'd0;
                            hh_units <= 4'd1;
                            pm <= ~pm;
                        end else if (hh_units == 4'd9) begin
                            // For hours 09 to 10: hh_tens increments, hh_units reset to 0
                            hh_tens <= hh_tens + 4'd1;
                            hh_units <= 4'd0;
                        end else begin
                            hh_units <= hh_units + 4'd1;
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

// Output assignments combinationally from BCD registers
always @(*) begin
    hh = {hh_tens, hh_units};
    mm = {mm_tens, mm_units};
    ss = {ss_tens, ss_units};
end

endmodule