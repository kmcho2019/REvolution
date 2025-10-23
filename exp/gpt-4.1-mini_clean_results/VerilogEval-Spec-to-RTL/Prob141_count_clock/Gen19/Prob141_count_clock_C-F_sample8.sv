module TopModule(
    input  wire       clk,
    input  wire       reset,
    input  wire       ena,
    output reg        pm,
    output reg [7:0]  hh,
    output reg [7:0]  mm,
    output reg [7:0]  ss
);

    // Seconds BCD counters: tens (0-5), units (0-9)
    reg [3:0] sec_units;
    reg [3:0] sec_tens;

    // Minutes BCD counters: tens (0-5), units (0-9)
    reg [3:0] min_units;
    reg [3:0] min_tens;

    // Hours binary counter (1-12)
    reg [3:0] hour_bin;

    // Combinational rollover signals
    wire sec_rollover = (sec_tens == 4'd5) && (sec_units == 4'd9);
    wire min_rollover = (min_tens == 4'd5) && (min_units == 4'd9);

    always @(posedge clk) begin
        if (reset) begin
            // Synchronous reset to 12:00:00 AM
            sec_units <= 4'd0;
            sec_tens  <= 4'd0;
            min_units <= 4'd0;
            min_tens  <= 4'd0;
            hour_bin  <= 4'd12;
            pm        <= 1'b0;
        end else if (ena) begin
            // Increment seconds BCD
            if (sec_units == 4'd9) begin
                sec_units <= 4'd0;
                if (sec_tens == 4'd5) begin
                    sec_tens <= 4'd0;
                end else begin
                    sec_tens <= sec_tens + 4'd1;
                end
            end else begin
                sec_units <= sec_units + 4'd1;
            end

            // Increment minutes on seconds rollover
            if (sec_rollover) begin
                if (min_units == 4'd9) begin
                    min_units <= 4'd0;
                    if (min_tens == 4'd5) begin
                        min_tens <= 4'd0;
                    end else begin
                        min_tens <= min_tens + 4'd1;
                    end
                end else begin
                    min_units <= min_units + 4'd1;
                end

                // Increment hours on minutes rollover
                if (min_rollover) begin
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

    // Convert binary hour (1..12) to BCD (two digits) combinationally
    always @* begin
        if (hour_bin >= 4'd10) begin
            hh = {4'd1, hour_bin - 4'd10};
        end else begin
            hh = {4'd0, hour_bin};
        end
    end

    // Concatenate tens and units for minutes and seconds outputs combinationally
    always @* begin
        mm = {min_tens, min_units};
        ss = {sec_tens, sec_units};
    end

endmodule