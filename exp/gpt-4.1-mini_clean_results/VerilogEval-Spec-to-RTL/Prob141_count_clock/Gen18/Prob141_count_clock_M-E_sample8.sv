module TopModule(
    input  wire       clk,
    input  wire       reset,
    input  wire       ena,
    output reg        pm,
    output reg [7:0]  hh,
    output reg [7:0]  mm,
    output reg [7:0]  ss
);

// Seconds counter: two BCD digits (0-5 tens, 0-9 units)
reg [3:0] sec_units;
reg [3:0] sec_tens;

// Minutes counter: two BCD digits (0-5 tens, 0-9 units)
reg [3:0] min_units;
reg [3:0] min_tens;

// Hours counter: two BCD digits (01-12)
// tens: 0 or 1, units: 1-9 or 0-2 depending on tens
reg [3:0] hour_tens;
reg [3:0] hour_units;

// --- Seconds counter ---
wire sec_units_wrap = (sec_units == 4'd9);
wire sec_tens_wrap  = (sec_tens == 4'd5);

always @(posedge clk) begin
    if (reset) begin
        sec_units <= 4'd0;
        sec_tens  <= 4'd0;
    end else if (ena) begin
        if (sec_units_wrap) begin
            sec_units <= 4'd0;
            if (sec_tens_wrap)
                sec_tens <= 4'd0;
            else
                sec_tens <= sec_tens + 4'd1;
        end else begin
            sec_units <= sec_units + 4'd1;
        end
    end
end

wire seconds_rollover = (sec_units_wrap && sec_tens_wrap) && ena;

// --- Minutes counter ---
wire min_units_wrap = (min_units == 4'd9);
wire min_tens_wrap  = (min_tens == 4'd5);

always @(posedge clk) begin
    if (reset) begin
        min_units <= 4'd0;
        min_tens  <= 4'd0;
    end else if (seconds_rollover) begin
        if (min_units_wrap) begin
            min_units <= 4'd0;
            if (min_tens_wrap)
                min_tens <= 4'd0;
            else
                min_tens <= min_tens + 4'd1;
        end else begin
            min_units <= min_units + 4'd1;
        end
    end
end

wire minutes_rollover = (min_units_wrap && min_tens_wrap) && seconds_rollover;

// --- Hours counter ---
// Hours in BCD counting 1 to 12:
// Valid hour values:
// 01..09: tens=0 units=1..9
// 10..12: tens=1 units=0..2
// After 12 -> 1

// Detect hour is 12
wire hour_is_12 = (hour_tens == 4'd1) && (hour_units == 4'd2);
// Detect hour is 11 (for PM toggle)
wire hour_is_11 = (hour_tens == 4'd1) && (hour_units == 4'd1);

always @(posedge clk) begin
    if (reset) begin
        hour_tens  <= 4'd1; // '1'
        hour_units <= 4'd2; // '2' (12)
        pm         <= 1'b0; // AM
    end else if (minutes_rollover) begin
        // Increment hour
        if (hour_is_12) begin
            // Wrap to 1
            hour_tens  <= 4'd0;
            hour_units <= 4'd1;
        end else if (hour_units == 4'd9) begin
            // Transition from 09 to 10
            hour_tens  <= hour_tens + 4'd1;
            hour_units <= 4'd0;
        end else begin
            // Normal increment units
            hour_units <= hour_units + 4'd1;
        end

        // Toggle PM at 11->12 transition
        if (hour_is_11)
            pm <= ~pm;
    end
end

// Assign outputs as concatenations of BCD digits
always @(*) begin
    hh = {hour_tens, hour_units};
    mm = {min_tens, min_units};
    ss = {sec_tens, sec_units};
end

endmodule