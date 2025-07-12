module TopModule(
    input  wire       clk,
    input  wire       reset,
    input  wire       ena,
    output reg        pm,
    output wire [7:0] hh,
    output wire [7:0] mm,
    output wire [7:0] ss
);

    // Seconds and minutes BCD digits
    reg [3:0] ss_units, ss_tens;
    reg [3:0] mm_units, mm_tens;

    // Hour internal binary counter (1..12)
    reg [3:0] hour_bin;

    // Carry signals for rollovers
    wire sec_carry;
    wire min_carry;

    // Increment logic inside single sequential always block with explicit carries
    always @(posedge clk) begin
        if (reset) begin
            // Reset to 12:00:00 AM
            ss_units <= 4'd0;
            ss_tens  <= 4'd0;
            mm_units <= 4'd0;
            mm_tens  <= 4'd0;
            hour_bin <= 4'd12;
            pm       <= 1'b0;
        end else if (ena) begin
            // Seconds increment
            if (ss_units == 4'd9) begin
                ss_units <= 4'd0;
                if (ss_tens == 4'd5) begin
                    ss_tens <= 4'd0;
                end else begin
                    ss_tens <= ss_tens + 4'd1;
                end
            end else begin
                ss_units <= ss_units + 4'd1;
            end

            // Minutes increment on seconds rollover
            if ((ss_tens == 4'd5) && (ss_units == 4'd9)) begin
                if (mm_units == 4'd9) begin
                    mm_units <= 4'd0;
                    if (mm_tens == 4'd5) begin
                        mm_tens <= 4'd0;
                    end else begin
                        mm_tens <= mm_tens + 4'd1;
                    end
                end else begin
                    mm_units <= mm_units + 4'd1;
                end

                // Hours increment on minutes rollover
                if ((mm_tens == 4'd5) && (mm_units == 4'd9)) begin
                    if (hour_bin == 4'd12) begin
                        hour_bin <= 4'd1;
                    end else begin
                        hour_bin <= hour_bin + 4'd1;
                    end

                    // Toggle pm when hour rolls from 11 to 12
                    if (hour_bin == 4'd11) begin
                        pm <= ~pm;
                    end
                end
            end
        end
    end

    // Output assignments

    // Hours BCD conversion from binary hour_bin (1..12)
    // Output format: [tens][units]
    assign hh = (hour_bin > 4'd9) ? {4'd1, hour_bin - 4'd10} : {4'd0, hour_bin};

    // Minutes and seconds output as concatenation of tens and units digits
    assign mm = {mm_tens, mm_units};
    assign ss = {ss_tens, ss_units};

endmodule