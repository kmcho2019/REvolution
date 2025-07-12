module TopModule(
    input  wire       clk,
    input  wire       reset,
    input  wire       ena,
    output reg        pm,
    output reg [7:0]  hh,
    output reg [7:0]  mm,
    output reg [7:0]  ss
);

// BCD digits for seconds (0-59)
reg [3:0] sec_units;
reg [3:0] sec_tens; // max 5

// BCD digits for minutes (0-59)
reg [3:0] min_units;
reg [3:0] min_tens; // max 5

// BCD digits for hours (01-12)
reg [3:0] hour_units;
reg [3:0] hour_tens; // 0 or 1 only

// Rollover signals for chaining
wire sec_rollover, min_rollover, hour_rollover;

// Seconds counter
always @(posedge clk) begin
    if (reset) begin
        sec_units <= 4'd0;
        sec_tens  <= 4'd0;
    end else if (ena) begin
        if (sec_units == 4'd9) begin
            sec_units <= 4'd0;
            if (sec_tens == 4'd5)
                sec_tens <= 4'd0;
            else
                sec_tens <= sec_tens + 4'd1;
        end else begin
            sec_units <= sec_units + 4'd1;
        end
    end
end

assign sec_rollover = ena && (sec_units == 4'd9) && (sec_tens == 4'd5);

// Minutes counter
always @(posedge clk) begin
    if (reset) begin
        min_units <= 4'd0;
        min_tens  <= 4'd0;
    end else if (sec_rollover) begin
        if (min_units == 4'd9) begin
            min_units <= 4'd0;
            if (min_tens == 4'd5)
                min_tens <= 4'd0;
            else
                min_tens <= min_tens + 4'd1;
        end else begin
            min_units <= min_units + 4'd1;
        end
    end
end

assign min_rollover = sec_rollover && (min_units == 4'd9) && (min_tens == 4'd5);

// Hours counter (BCD) increments on minute rollover
always @(posedge clk) begin
    if (reset) begin
        hour_tens  <= 4'd1; // '1' for 12
        hour_units <= 4'd2; // '2' for 12
        pm         <= 1'b0; // AM
    end else if (min_rollover) begin
        // Increment hour BCD from 12 to 1-11 then back to 12
        if ((hour_tens == 4'd1) && (hour_units == 4'd2)) begin
            // 12 -> 1
            hour_tens  <= 4'd0;
            hour_units <= 4'd1;
        end else if ((hour_tens == 4'd0) && (hour_units == 4'd9)) begin
            // 9 -> 10
            hour_tens  <= 4'd1;
            hour_units <= 4'd0;
        end else begin
            // Increment units digit
            hour_units <= hour_units + 4'd1;
        end

        // Toggle pm when hour rolls from 11 to 12
        // Detect hour before increment: if hour is 11, next hour is 12 toggle pm
        if ((hour_tens == 4'd0) && (hour_units == 4'd11)) begin
            pm <= ~pm;
        end
    end
end

// Output assignments: direct concatenation of BCD digits
always @(*) begin
    hh = {hour_tens, hour_units};
    mm = {min_tens, min_units};
    ss = {sec_tens, sec_units};
end

endmodule