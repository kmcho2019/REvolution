module TopModule(
    input  wire       clk,
    input  wire       reset,
    input  wire       ena,
    output reg        pm,
    output reg [7:0]  hh,
    output reg [7:0]  mm,
    output reg [7:0]  ss
);

// Separate BCD digits for seconds and minutes
reg [3:0] ss_units, ss_tens;
reg [3:0] mm_units, mm_tens;

// Separate BCD digits for hours
reg [3:0] hh_units, hh_tens;

// Convenience signals for hour rollover detection
wire hour_is_11 = (hh_tens == 4'd1) && (hh_units == 4'd1);
wire hour_is_12 = (hh_tens == 4'd1) && (hh_units == 4'd2);
wire hour_is_09 = (hh_tens == 4'd0) && (hh_units == 4'd9);

always @(posedge clk) begin
    if (reset) begin
        // Reset to 12:00:00 AM
        pm       <= 1'b0;      // AM
        hh_tens  <= 4'd1;
        hh_units <= 4'd2;
        mm_tens  <= 4'd0;
        mm_units <= 4'd0;
        ss_tens  <= 4'd0;
        ss_units <= 4'd0;
    end else if (ena) begin
        // Increment seconds units
        if (ss_units == 4'd9) begin
            ss_units <= 4'd0;
            // Increment seconds tens
            if (ss_tens == 4'd5) begin
                ss_tens <= 4'd0;
                // Increment minutes units
                if (mm_units == 4'd9) begin
                    mm_units <= 4'd0;
                    // Increment minutes tens
                    if (mm_tens == 4'd5) begin
                        mm_tens <= 4'd0;
                        // Increment hour units and tens with explicit rollover rules
                        if (hour_is_11) begin
                            // From 11 to 12, toggle PM and set hour to 12
                            pm <= ~pm;
                            hh_tens  <= 4'd1;
                            hh_units <= 4'd2;
                        end else if (hour_is_12) begin
                            // From 12 to 1
                            hh_tens  <= 4'd0;
                            hh_units <= 4'd1;
                        end else if (hour_is_09) begin
                            // From 9 to 10
                            hh_tens  <= 4'd1;
                            hh_units <= 4'd0;
                        end else begin
                            // Normal increment hours units digit
                            if (hh_units == 4'd9) begin
                                hh_units <= 4'd0;
                                hh_tens <= hh_tens + 4'd1; // Only 0->1 transition expected here
                            end else begin
                                hh_units <= hh_units + 4'd1;
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

// Combinational assignment of outputs from BCD digits
always @(*) begin
    hh = {hh_tens, hh_units};
    mm = {mm_tens, mm_units};
    ss = {ss_tens, ss_units};
end

endmodule