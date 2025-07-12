module TopModule(
    input  wire       clk,
    input  wire       reset,
    input  wire       ena,
    output reg        pm,
    output reg [7:0]  hh,
    output reg [7:0]  mm,
    output reg [7:0]  ss
);

    // Seconds counters (BCD): units (0-9), tens (0-5)
    reg [3:0] sec_units;
    reg [2:0] sec_tens; // max 5

    // Minutes counters (BCD): units (0-9), tens (0-5)
    reg [3:0] min_units;
    reg [2:0] min_tens; // max 5

    // Hours counters (BCD): tens (0 or 1), units (1-9)
    reg [3:0] hr_units; // 0-9 BCD units digit
    reg       hr_tens;  // 0 or 1, tens digit

    // Helper to check if hour is 12 in BCD
    wire hour_is_12 = (hr_tens == 1'b1) && (hr_units == 4'd2);
    // Helper to check if hour is 11 in BCD
    wire hour_is_11 = (hr_tens == 1'b1) && (hr_units == 4'd1);

    // Seconds units counter
    always @(posedge clk) begin
        if (reset) begin
            sec_units <= 4'd0;
        end else if (ena) begin
            if (sec_units == 4'd9) begin
                sec_units <= 4'd0;
            end else begin
                sec_units <= sec_units + 1;
            end
        end
    end

    // Seconds tens counter
    always @(posedge clk) begin
        if (reset) begin
            sec_tens <= 3'd0;
        end else if (ena && sec_units == 4'd9) begin
            if (sec_tens == 3'd5) begin
                sec_tens <= 3'd0;
            end else begin
                sec_tens <= sec_tens + 1;
            end
        end
    end

    // Minutes units counter
    always @(posedge clk) begin
        if (reset) begin
            min_units <= 4'd0;
        end else if (ena && sec_units == 4'd9 && sec_tens == 3'd5) begin
            if (min_units == 4'd9) begin
                min_units <= 4'd0;
            end else begin
                min_units <= min_units + 1;
            end
        end
    end

    // Minutes tens counter
    always @(posedge clk) begin
        if (reset) begin
            min_tens <= 3'd0;
        end else if (ena && sec_units == 4'd9 && sec_tens == 3'd5 && min_units == 4'd9) begin
            if (min_tens == 3'd5) begin
                min_tens <= 3'd0;
            end else begin
                min_tens <= min_tens + 1;
            end
        end
    end

    // Hours units counter
    always @(posedge clk) begin
        if (reset) begin
            hr_units <= 4'd2;  // 12: units digit = 2
        end else if (ena && sec_units == 4'd9 && sec_tens == 3'd5 
                      && min_units == 4'd9 && min_tens == 3'd5) begin
            if (hour_is_12) begin
                hr_units <= 4'd1; // roll to 1
            end else if (hr_units == 4'd9) begin
                hr_units <= 4'd0; // roll to 0, tens digit will increase next
            end else begin
                hr_units <= hr_units + 1;
            end
        end
    end

    // Hours tens counter
    always @(posedge clk) begin
        if (reset) begin
            hr_tens <= 1'b1;  // 12: tens digit = 1
            pm <= 1'b0;       // AM
        end else if (ena && sec_units == 4'd9 && sec_tens == 3'd5 
                      && min_units == 4'd9 && min_tens == 3'd5) begin
            if (hour_is_12) begin
                hr_tens <= 1'b0;  // roll over to 01
                pm <= ~pm;        // toggle PM at 12 rollover
            end else if (hr_units == 4'd9) begin
                hr_tens <= 1'b1;  // increment tens digit from 0 to 1 (i.e., 9 to 10)
            end
            // else no change
        end
    end

    // Output assignments
    always @* begin
        hh = {hr_tens ? 4'd1 : 4'd0, hr_units};
        mm = {min_tens, min_units};
        ss = {sec_tens, sec_units};
    end

endmodule