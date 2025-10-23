module TopModule(
    input  wire       clk,
    input  wire       reset,
    input  wire       ena,
    output reg        pm,
    output reg  [7:0] hh,
    output reg  [7:0] mm,
    output reg  [7:0] ss
);

    // Seconds BCD digits: units (0-9), tens (0-5)
    reg [3:0] sec_units;
    reg [2:0] sec_tens;  // 0 to 5

    // Minutes BCD digits: units (0-9), tens (0-5)
    reg [3:0] min_units;
    reg [2:0] min_tens;  // 0 to 5

    // Hours counter (1..12 binary)
    reg [3:0] hours;

    always @(posedge clk) begin
        if (reset) begin
            pm        <= 1'b0;      // AM
            sec_units <= 4'd0;
            sec_tens  <= 3'd0;
            min_units <= 4'd0;
            min_tens  <= 3'd0;
            hours     <= 4'd12;
        end else if (ena) begin
            // Increment seconds units digit
            if (sec_units == 4'd9) begin
                sec_units <= 4'd0;
                // Increment seconds tens digit
                if (sec_tens == 3'd5) begin
                    sec_tens <= 3'd0;
                    // Seconds rolled over -> increment minutes units digit
                    if (min_units == 4'd9) begin
                        min_units <= 4'd0;
                        // Increment minutes tens digit
                        if (min_tens == 3'd5) begin
                            min_tens <= 3'd0;
                            // Minutes rolled over -> increment hours
                            if (hours == 4'd11) begin
                                hours <= 4'd12;
                                pm <= ~pm;  // Toggle PM at rollover from 11 to 12
                            end else if (hours == 4'd12) begin
                                hours <= 4'd1;
                            end else begin
                                hours <= hours + 4'd1;
                            end
                        end else begin
                            min_tens <= min_tens + 3'd1;
                        end
                    end else begin
                        min_units <= min_units + 4'd1;
                    end
                end else begin
                    sec_tens <= sec_tens + 3'd1;
                end
            end else begin
                sec_units <= sec_units + 4'd1;
            end
        end
    end

    // Convert hours binary (1-12) to BCD output (8 bits)
    always @* begin
        if (hours >= 10)
            hh = {4'd1, hours - 4'd10};
        else
            hh = {4'd0, hours};
    end

    // Assign minutes and seconds outputs by concatenating tens and units digits
    always @* begin
        mm = {min_tens, min_units};
        ss = {sec_tens, sec_units};
    end

endmodule