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

    // Hours counters: tens (0 or 1), units (0-9)
    reg [3:0] hour_units;
    reg        hour_tens;  // 1 bit is enough for tens digit (0 or 1)

    // Internal wires for hour value check (to detect wrap and pm toggle)
    wire hour_is_11;
    wire hour_is_12;

    assign hour_is_11 = (hour_tens == 1'b0) && (hour_units == 4'd11);
    assign hour_is_12 = (hour_tens == 1'b1) && (hour_units == 4'd2);

    always @(posedge clk) begin
        if (reset) begin
            pm <= 1'b0;       // AM
            sec_units <= 4'd0;
            sec_tens  <= 3'd0;
            min_units <= 4'd0;
            min_tens  <= 3'd0;
            hour_tens <= 1'b1;  // tens digit = 1
            hour_units <= 4'd2; // units digit = 2 => 12
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
                            if (hour_is_12) begin
                                // wrap to 1:00
                                hour_tens <= 1'b0;
                                hour_units <= 4'd1;
                                pm <= ~pm; // toggle PM
                            end else if (hour_units == 4'd9) begin
                                // tens digit must be 0 to get here (can't be 1 for 19)
                                hour_tens <= 1'b1;
                                hour_units <= 4'd0;
                            end else begin
                                hour_units <= hour_units + 4'd1;
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

    // Output assignments are direct concatenations of BCD digits
    always @* begin
        hh = {hour_tens ? 4'd1 : 4'd0, hour_units};
        mm = {min_tens, min_units};
        ss = {sec_tens, sec_units};
    end

endmodule