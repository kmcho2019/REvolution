module TopModule(
    input  wire       clk,
    input  wire       reset,
    input  wire       ena,
    output reg        pm,
    output reg [7:0]  hh,
    output reg [7:0]  mm,
    output reg [7:0]  ss
);

    // Seconds counters: tens (0-5), units (0-9)
    reg [3:0] sec_units;
    reg [2:0] sec_tens; // max 5

    // Minutes counters: tens (0-5), units (0-9)
    reg [3:0] min_units;
    reg [2:0] min_tens; // max 5

    // Hours counter (1-12 binary)
    reg [3:0] hours;

    always @(posedge clk) begin
        if (reset) begin
            pm <= 1'b0;      // AM
            sec_units <= 4'd0;
            sec_tens  <= 3'd0;
            min_units <= 4'd0;
            min_tens  <= 3'd0;
            hours     <= 4'd12;
        end else if (ena) begin
            // Increment seconds
            if (sec_units == 4'd9) begin
                sec_units <= 4'd0;
                if (sec_tens == 3'd5) begin
                    sec_tens <= 3'd0;
                    // Increment minutes
                    if (min_units == 4'd9) begin
                        min_units <= 4'd0;
                        if (min_tens == 3'd5) begin
                            min_tens <= 3'd0;
                            // Increment hours
                            if (hours == 4'd11) begin
                                hours <= 4'd12;
                                pm <= ~pm; // toggle PM
                            end else if (hours == 4'd12) begin
                                hours <= 4'd1;
                            end else begin
                                hours <= hours + 1;
                            end
                        end else begin
                            min_tens <= min_tens + 1;
                        end
                    end else begin
                        min_units <= min_units + 1;
                    end
                end else begin
                    sec_tens <= sec_tens + 1;
                end
            end else begin
                sec_units <= sec_units + 1;
            end
        end
    end

    // Convert hours binary (1-12) to BCD for output (8 bits)
    always @* begin
        if (hours >= 10) begin
            hh = {4'd1, hours - 4'd10};
        end else begin
            hh = {4'd0, hours};
        end
    end

    // Assign minutes and seconds outputs by concatenating tens and units digits
    always @* begin
        mm = {min_tens, min_units};
        ss = {sec_tens, sec_units};
    end

endmodule