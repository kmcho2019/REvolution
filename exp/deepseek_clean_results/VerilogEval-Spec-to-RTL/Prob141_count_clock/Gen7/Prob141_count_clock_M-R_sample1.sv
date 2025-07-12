module TopModule (
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

    // BCD counters (stored as {tens, ones})
    reg [3:0] sec_ones, sec_tens;
    reg [3:0] min_ones, min_tens;
    reg [3:0] hour_tens, hour_ones;  // Direct BCD storage (01-12)

    // Increment conditions (combinational)
    wire sec_roll = (sec_ones == 4'd9) && (sec_tens == 4'd5);
    wire min_roll = (min_ones == 4'd9) && (min_tens == 4'd5);
    wire hour_roll = (hour_ones == 4'd2) && (hour_tens == 4'd1); // 12->01

    wire do_sec_inc = ena;
    wire do_min_inc = do_sec_inc && sec_roll;
    wire do_hour_inc = do_min_inc && min_roll;

    // Seconds counter (00-59)
    always @(posedge clk) begin
        if (reset) begin
            sec_ones <= 4'd0;
            sec_tens <= 4'd0;
        end else if (do_sec_inc) begin
            if (sec_ones == 4'd9) begin
                sec_ones <= 4'd0;
                sec_tens <= sec_tens + 1;
            end else begin
                sec_ones <= sec_ones + 1;
            end
        end
    end

    // Minutes counter (00-59)
    always @(posedge clk) begin
        if (reset) begin
            min_ones <= 4'd0;
            min_tens <= 4'd0;
        end else if (do_min_inc) begin
            if (min_ones == 4'd9) begin
                min_ones <= 4'd0;
                min_tens <= min_tens + 1;
            end else begin
                min_ones <= min_ones + 1;
            end
        end
    end

    // Hours counter (01-12 in BCD)
    always @(posedge clk) begin
        if (reset) begin
            hour_tens <= 4'd1;
            hour_ones <= 4'd2;  // 12:00
        end else if (do_hour_inc) begin
            if (hour_roll) begin
                hour_tens <= 4'd0;
                hour_ones <= 4'd1;  // 12->01
            end else if (hour_ones == 4'd9) begin
                hour_tens <= hour_tens + 1;
                hour_ones <= 4'd0;
            end else begin
                hour_ones <= hour_ones + 1;
            end
        end
    end

    // PM indicator (combinational based on hour count)
    // PM is active when hour is 12-11 (12:00 PM to 11:59 PM)
    assign pm = (hour_tens == 4'd1 && hour_ones >= 4'd2) ||  // 12 PM
                (hour_tens == 4'd0 && hour_ones >= 4'd1);    // 1-11 PM

    // Direct BCD outputs
    assign ss = {sec_tens, sec_ones};
    assign mm = {min_tens, min_ones};
    assign hh = {hour_tens, hour_ones};

endmodule