module TopModule(
    input  wire       clk,
    input  wire       reset,
    input  wire       ena,
    output reg        pm,
    output reg [7:0]  hh,
    output reg [7:0]  mm,
    output reg [7:0]  ss
);

// Internal BCD digits for seconds and minutes
reg [3:0] ss_units, ss_tens;
reg [3:0] mm_units, mm_tens;

// Internal binary hour counter (1 to 12)
reg [3:0] hour_bin;

// Internal signals for rollover detection
wire sec_rollover;
wire min_rollover;
wire hour_rollover_11_to_12;

// Sequential logic: synchronous reset and enable gated counter increments
always @(posedge clk) begin
    if (reset) begin
        // Reset clock to 12:00:00 AM
        pm       <= 1'b0;    // AM
        hour_bin <= 4'd12;
        mm_tens  <= 4'd0;
        mm_units <= 4'd0;
        ss_tens  <= 4'd0;
        ss_units <= 4'd0;
    end else if (ena) begin
        // Increment seconds units digit
        if (ss_units == 4'd9) begin
            ss_units <= 4'd0;
            // Increment seconds tens digit
            if (ss_tens == 4'd5) begin
                ss_tens <= 4'd0;
                // Seconds rolled over: increment minutes units digit
                if (mm_units == 4'd9) begin
                    mm_units <= 4'd0;
                    // Increment minutes tens digit
                    if (mm_tens == 4'd5) begin
                        mm_tens <= 4'd0;
                        // Minutes rolled over: increment hour
                        if (hour_bin == 4'd12) begin
                            hour_bin <= 4'd1;
                        end else begin
                            hour_bin <= hour_bin + 4'd1;
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

        // Toggle pm when hour increments from 11 to 12
        // This happens when previous hour was 11 and we increment hour_bin to 12
        if ((hour_bin == 4'd11) && ((ss_tens == 4'd5) && (ss_units == 4'd9) &&
            (mm_tens == 4'd5) && (mm_units == 4'd9))) begin
            pm <= ~pm;
        end
    end
end

// Combinational output logic for hour BCD conversion
always @* begin
    // Hour BCD output (hh)
    if (hour_bin <= 4'd9) begin
        hh = {4'd0, hour_bin}; // Tens = 0, Units = hour_bin
    end else begin
        // 10 to 12 hours: tens = 1, units = hour_bin - 10
        hh = {4'd1, hour_bin - 4'd10};
    end
    // Minutes and seconds outputs are concatenation of tens and units
    mm = {mm_tens, mm_units};
    ss = {ss_tens, ss_units};
end

endmodule