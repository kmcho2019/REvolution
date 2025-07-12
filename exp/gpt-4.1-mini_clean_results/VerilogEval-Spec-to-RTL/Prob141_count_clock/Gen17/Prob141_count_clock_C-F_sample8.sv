module TopModule(
    input  wire       clk,
    input  wire       reset,
    input  wire       ena,
    output reg        pm,
    output reg [7:0]  hh,
    output reg [7:0]  mm,
    output reg [7:0]  ss
);

    // Seconds BCD digits: units (0-9), tens (0-5)
    reg [3:0] ss_units;
    reg [3:0] ss_tens;

    // Minutes BCD digits: units (0-9), tens (0-5)
    reg [3:0] mm_units;
    reg [3:0] mm_tens;

    // Hours stored internally as binary (1..12)
    reg [3:0] hour_bin;

    // Combinational signals for rollovers
    wire sec_rollover = (ss_tens == 4'd5) && (ss_units == 4'd9);
    wire min_rollover = (mm_tens == 4'd5) && (mm_units == 4'd9);

    always @(posedge clk) begin
        if (reset) begin
            // Synchronous reset to 12:00:00 AM
            ss_units <= 4'd0;
            ss_tens  <= 4'd0;
            mm_units <= 4'd0;
            mm_tens  <= 4'd0;
            hour_bin <= 4'd12;
            pm       <= 1'b0;
        end else if (ena) begin
            // Increment seconds
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

            // Increment minutes on seconds rollover
            if (sec_rollover) begin
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

                // Increment hours on minutes rollover
                if (min_rollover) begin
                    if (hour_bin == 4'd12) begin
                        hour_bin <= 4'd1;
                    end else begin
                        hour_bin <= hour_bin + 4'd1;
                    end

                    // Toggle pm signal on hour transition 11 -> 12
                    if (hour_bin == 4'd11) begin
                        pm <= ~pm;
                    end
                end
            end
        end
    end

    // Convert hour binary (1..12) to BCD output combinationally
    always @(*) begin
        if (hour_bin >= 4'd10)
            hh = {4'd1, hour_bin - 4'd10};
        else
            hh = {4'd0, hour_bin};
    end

    // Minutes and seconds output concatenation
    always @(*) begin
        mm = {mm_tens, mm_units};
        ss = {ss_tens, ss_units};
    end

endmodule