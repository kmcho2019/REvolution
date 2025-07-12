module TopModule(
    input  wire       clk,
    input  wire       reset,
    input  wire       ena,
    output reg        pm,
    output reg [7:0]  hh,
    output reg [7:0]  mm,
    output reg [7:0]  ss
);

// Seconds counter BCD (two digits)
reg [3:0] ss_units, ss_tens;
// Minutes counter BCD (two digits)
reg [3:0] mm_units, mm_tens;
// Hour counter binary (1 to 12)
reg [3:0] hour_bin;

// Seconds and minutes increment logic combined
always @(posedge clk) begin
    if (reset) begin
        ss_units <= 4'd0;
        ss_tens  <= 4'd0;
        mm_units <= 4'd0;
        mm_tens  <= 4'd0;
    end else if (ena) begin
        // Increment seconds
        if (ss_units == 4'd9) begin
            ss_units <= 4'd0;
            if (ss_tens == 4'd5) begin
                ss_tens <= 4'd0;
                // Increment minutes
                if (mm_units == 4'd9) begin
                    mm_units <= 4'd0;
                    if (mm_tens == 4'd5)
                        mm_tens <= 4'd0;
                    else
                        mm_tens <= mm_tens + 4'd1;
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

// Hour and PM update on minute rollover (when minutes wrap from 59 to 00)
wire min_rollover = (mm_tens == 4'd5) && (mm_units == 4'd9) &&
                    (ss_tens == 4'd5) && (ss_units == 4'd9) && ena;

always @(posedge clk) begin
    if (reset) begin
        hour_bin <= 4'd12;
        pm <= 1'b0; // AM
    end else if (min_rollover) begin
        if (hour_bin == 4'd12)
            hour_bin <= 4'd1;
        else
            hour_bin <= hour_bin + 4'd1;
        // Toggle pm when hour rolls from 11 to 12
        if (hour_bin == 4'd11)
            pm <= ~pm;
    end
end

// Combinational output assignments
always @(*) begin
    // Hours: convert binary (1..12) to two-digit BCD
    if (hour_bin <= 4'd9)
        hh = {4'd0, hour_bin};
    else
        hh = {4'd1, hour_bin - 4'd10};

    mm = {mm_tens, mm_units};
    ss = {ss_tens, ss_units};
end

endmodule