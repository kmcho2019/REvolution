module TopModule(
    input  wire       clk,
    input  wire       reset,
    input  wire       ena,
    output reg        pm,
    output wire [7:0] hh,
    output wire [7:0] mm,
    output wire [7:0] ss
);

// Internal registers for seconds and minutes BCD digits
reg [3:0] ss_units, ss_tens;
reg [3:0] mm_units, mm_tens;
// Hour stored as binary 1..12
reg [3:0] hour_bin;

always @(posedge clk) begin
    if (reset) begin
        // Initialize to 12:00:00 AM
        ss_units <= 4'd0;
        ss_tens  <= 4'd0;
        mm_units <= 4'd0;
        mm_tens  <= 4'd0;
        hour_bin <= 4'd12;
        pm       <= 1'b0; // AM
    end else if (ena) begin
        // Seconds increment
        if (ss_units == 4'd9) begin
            ss_units <= 4'd0;
            if (ss_tens == 4'd5) begin
                ss_tens <= 4'd0;
                // Minutes increment on seconds rollover
                if (mm_units == 4'd9) begin
                    mm_units <= 4'd0;
                    if (mm_tens == 4'd5) begin
                        mm_tens <= 4'd0;
                        // Hours increment on minutes rollover
                        if (hour_bin == 4'd12)
                            hour_bin <= 4'd1;
                        else
                            hour_bin <= hour_bin + 4'd1;
                        // Toggle pm on hour transition from 11 to 12
                        if (hour_bin == 4'd11)
                            pm <= ~pm;
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

// Combinational hour BCD conversion
// If hour_bin <= 9: BCD is 0x0 | hour_bin
// else (10..12): 0x1 | (hour_bin - 10)
wire [7:0] hour_bcd = (hour_bin <= 4'd9) ? {4'd0, hour_bin} : {4'd1, hour_bin - 4'd10};

assign hh = hour_bcd;
assign mm = {mm_tens, mm_units};
assign ss = {ss_tens, ss_units};

endmodule