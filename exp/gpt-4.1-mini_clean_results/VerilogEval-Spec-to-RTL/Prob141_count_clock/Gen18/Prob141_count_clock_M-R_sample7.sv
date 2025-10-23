module TopModule(
    input  wire       clk,
    input  wire       reset,
    input  wire       ena,
    output reg        pm,
    output wire [7:0] hh,
    output wire [7:0] mm,
    output wire [7:0] ss
);

    // Internal binary counters
    reg [5:0] seconds; // 0-59
    reg [5:0] minutes; // 0-59
    reg [3:0] hours;   // 1-12

    // Main counter always block: synchronous reset and enable
    always @(posedge clk) begin
        if (reset) begin
            pm      <= 1'b0;     // AM
            seconds <= 6'd0;
            minutes <= 6'd0;
            hours   <= 4'd12;
        end else if (ena) begin
            if (seconds == 6'd59) begin
                seconds <= 6'd0;
                if (minutes == 6'd59) begin
                    minutes <= 6'd0;
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

    // Instantiate BCD converters for seconds, minutes, and hours
    BinaryToBCD_60 bcd_sec (
        .bin(seconds),
        .bcd(ss)
    );

    BinaryToBCD_60 bcd_min (
        .bin(minutes),
        .bcd(mm)
    );

    BinaryToBCD_12 bcd_hour (
        .bin(hours),
        .bcd(hh)
    );

endmodule

// Convert binary [0..59] to BCD in 8 bits (2 digits)
module BinaryToBCD_60(
    input  wire [5:0] bin,
    output wire [7:0] bcd
);
    wire [3:0] tens;
    wire [3:0] units;

    // Determine tens digit by comparison
    assign tens = (bin >= 6'd50) ? 4'd5 :
                  (bin >= 6'd40) ? 4'd4 :
                  (bin >= 6'd30) ? 4'd3 :
                  (bin >= 6'd20) ? 4'd2 :
                  (bin >= 6'd10) ? 4'd1 : 4'd0;

    // Calculate units = bin - (tens * 10)
    // tens * 10 = (tens << 3) + (tens << 1)
    wire [7:0] tens_mul_10 = (tens << 3) + (tens << 1);
    assign units = bin - tens_mul_10[5:0];  // units fits in 4 bits

    assign bcd = {tens, units};

endmodule

// Convert binary hour (1..12) to BCD (two digits)
module BinaryToBCD_12(
    input  wire [3:0] bin,
    output wire [7:0] bcd
);
    wire [3:0] tens;
    wire [3:0] units;

    assign tens = (bin >= 4'd10) ? 4'd1 : 4'd0;
    assign units = (bin >= 4'd10) ? (bin - 4'd10) : bin;

    assign bcd = {tens, units};

endmodule