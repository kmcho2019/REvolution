module TopModule(
    input  wire       clk,
    input  wire       reset,
    input  wire       ena,
    output reg        pm,
    output reg [7:0]  hh,
    output reg [7:0]  mm,
    output reg [7:0]  ss
);

    // Internal binary counters
    reg [5:0] seconds; // 0 to 59
    reg [5:0] minutes; // 0 to 59
    reg [3:0] hours;   // 1 to 12

    // BCD digits for seconds and minutes (tens and units)
    reg [3:0] sec_tens, sec_units;
    reg [3:0] min_tens, min_units;
    reg [3:0] hr_tens, hr_units;

    // 1) Counting logic (hours, minutes, seconds) with synchronous reset and enable
    always @(posedge clk) begin
        if (reset) begin
            pm      <= 1'b0;   // AM
            seconds <= 6'd0;
            minutes <= 6'd0;
            hours   <= 4'd12;  // 12 o'clock
        end else if (ena) begin
            if (seconds == 6'd59) begin
                seconds <= 6'd0;
                if (minutes == 6'd59) begin
                    minutes <= 6'd0;
                    // Hour counting with PM toggle at 11->12 transition
                    if (hours == 4'd11) begin
                        hours <= 4'd12;
                        pm <= ~pm;
                    end else if (hours == 4'd12) begin
                        hours <= 4'd1;
                    end else begin
                        hours <= hours + 1;
                    end
                end else begin
                    minutes <= minutes + 1;
                end
            end else begin
                seconds <= seconds + 1;
            end
        end
    end

    // 2) Convert binary counters to BCD tens and units (combinational)
    always @(*) begin
        // Seconds conversion
        if (seconds >= 50)       sec_tens = 4'd5;
        else if (seconds >= 40)  sec_tens = 4'd4;
        else if (seconds >= 30)  sec_tens = 4'd3;
        else if (seconds >= 20)  sec_tens = 4'd2;
        else if (seconds >= 10)  sec_tens = 4'd1;
        else                     sec_tens = 4'd0;
        sec_units = seconds - (sec_tens * 4'd10);

        // Minutes conversion
        if (minutes >= 50)       min_tens = 4'd5;
        else if (minutes >= 40)  min_tens = 4'd4;
        else if (minutes >= 30)  min_tens = 4'd3;
        else if (minutes >= 20)  min_tens = 4'd2;
        else if (minutes >= 10)  min_tens = 4'd1;
        else                     min_tens = 4'd0;
        min_units = minutes - (min_tens * 4'd10);

        // Hours conversion (1-12)
        if (hours >= 10) begin
            hr_tens = 4'd1;
            hr_units = hours - 4'd10;
        end else begin
            hr_tens = 4'd0;
            hr_units = hours;
        end
    end

    // 3) Register the BCD outputs synchronously to reduce output combinational path
    always @(posedge clk) begin
        if (reset) begin
            hh <= 8'h12; // 0x12 = 12 decimal in BCD
            mm <= 8'h00;
            ss <= 8'h00;
        end else if (ena) begin
            hh <= {hr_tens, hr_units};
            mm <= {min_tens, min_units};
            ss <= {sec_tens, sec_units};
        end
    end

endmodule