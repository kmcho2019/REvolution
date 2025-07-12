module TopModule(
    input  clk,
    input  reset,
    input  ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

always @(posedge clk) begin
    if (reset) begin // Reset has higher priority than enable
        hh <= 8'b00010010; // 12 in BCD
        mm <= 8'b00000000; // 00 in BCD
        ss <= 8'b00000000; // 00 in BCD
        pm <= 1'b0; // AM
    end else if (ena) begin // Increment time if enable is asserted
        if (ss == 8'b00000000 && mm == 8'b00000000 && hh == 8'b00010010) begin
            hh <= 8'b00010010; // Wrap around to 12:00
            mm <= 8'b00000000;
            ss <= 8'b00000000;
            pm <= ~pm; // Toggle AM/PM
        end else if (ss == 8'b00000000 && mm == 8'b01010101) begin // 59 in BCD
            mm <= 8'b00000000; // Reset minutes
            if (hh == 8'b00010010) begin // 12 in BCD
                hh <= 8'b00010001; // Increment hours to 1
            end else if (hh == 8'b00010011) begin // 1 in BCD
                hh <= 8'b00010100; // Increment hours to 2
            end else if (hh == 8'b00010101) begin // 2 in BCD
                hh <= 8'b00010110; // Increment hours to 3
            end else if (hh == 8'b00010110) begin // 3 in BCD
                hh <= 8'b00010111; // Increment hours to 4
            end else if (hh == 8'b00010111) begin // 4 in BCD
                hh <= 8'b00011000; // Increment hours to 5
            end else if (hh == 8'b00011000) begin // 5 in BCD
                hh <= 8'b00011001; // Increment hours to 6
            end else if (hh == 8'b00011001) begin // 6 in BCD
                hh <= 8'b00011010; // Increment hours to 7
            end else if (hh == 8'b00011010) begin // 7 in BCD
                hh <= 8'b00011011; // Increment hours to 8
            end else if (hh == 8'b00011011) begin // 8 in BCD
                hh <= 8'b00011100; // Increment hours to 9
            end else if (hh == 8'b00011100) begin // 9 in BCD
                hh <= 8'b00011101; // Increment hours to 10
            end else if (hh == 8'b00011101) begin // 10 in BCD
                hh <= 8'b00011110; // Increment hours to 11
            end else if (hh == 8'b00011110) begin // 11 in BCD
                hh <= 8'b00011111; // Increment hours to 12
            end else if (hh == 8'b00011111) begin // 12 in BCD
                hh <= 8'b00010001; // Wrap around to 1
            end
            ss <= 8'b00000000; // Reset seconds
        end else if (ss == 8'b01010101) begin // 59 in BCD
            ss <= 8'b00000000; // Reset seconds
            if (mm == 8'b00000000) begin // 00 in BCD
                mm <= 8'b00000001; // Increment minutes to 1
            end else if (mm == 8'b00000001) begin // 1 in BCD
                mm <= 8'b00000010; // Increment minutes to 2
            end else if (mm == 8'b00000010) begin // 2 in BCD
                mm <= 8'b00000011; // Increment minutes to 3
            end else if (mm == 8'b00000011) begin // 3 in BCD
                mm <= 8'b00000100; // Increment minutes to 4
            end else if (mm == 8'b00000100) begin // 4 in BCD
                mm <= 8'b00000101; // Increment minutes to 5
            end else if (mm == 8'b00000101) begin // 5 in BCD
                mm <= 8'b00000110; // Increment minutes to 6
            end else if (mm == 8'b00000110) begin // 6 in BCD
                mm <= 8'b00000111; // Increment minutes to 7
            end else if (mm == 8'b00000111) begin // 7 in BCD
                mm <= 8'b00001000; // Increment minutes to 8
            end else if (mm == 8'b00001000) begin // 8 in BCD
                mm <= 8'b00001001; // Increment minutes to 9
            end else if (mm == 8'b00001001) begin // 9 in BCD
                mm <= 8'b00001010; // Increment minutes to 10
            end else if (mm == 8'b00001010) begin // 10 in BCD
                mm <= 8'b00001011; // Increment minutes to 11
            end else if (mm == 8'b00001011) begin // 11 in BCD
                mm <= 8'b00001100; // Increment minutes to 12
            end else if (mm == 8'b00001100) begin // 12 in BCD
                mm <= 8'b00001101; // Increment minutes to 13
            end else if (mm == 8'b00001101) begin // 13 in BCD
                mm <= 8'b00001110; // Increment minutes to 14
            end else if (mm == 8'b00001110) begin // 14 in BCD
                mm <= 8'b00001111; // Increment minutes to 15
            end else if (mm == 8'b00001111) begin // 15 in BCD
                mm <= 8'b00010000; // Increment minutes to 16
            end else if (mm == 8'b00010000) begin // 16 in BCD
                mm <= 8'b00010001; // Increment minutes to 17
            end else if (mm == 8'b00010001) begin // 17 in BCD
                mm <= 8'b00010010; // Increment minutes to 18
            end else if (mm == 8'b00010010) begin // 18 in BCD
                mm <= 8'b00010011; // Increment minutes to 19
            end else if (mm == 8'b00010011) begin // 19 in BCD
                mm <= 8'b00010100; // Increment minutes to 20
            end else if (mm == 8'b00010100) begin // 20 in BCD
                mm <= 8'b00010101; // Increment minutes to 21
            end else if (mm == 8'b00010101) begin // 21 in BCD
                mm <= 8'b00010110; // Increment minutes to 22
            end else if (mm == 8'b00010110) begin // 22 in BCD
                mm <= 8'b00010111; // Increment minutes to 23
            end else if (mm == 8'b00010111) begin // 23 in BCD
                mm <= 8'b00011000; // Increment minutes to 24
            end else if (mm == 8'b00011000) begin // 24 in BCD
                mm <= 8'b00011001; // Increment minutes to 25
            end else if (mm == 8'b00011001) begin // 25 in BCD
                mm <= 8'b00011010; // Increment minutes to 26
            end else if (mm == 8'b00011010) begin // 26 in BCD
                mm <= 8'b00011011; // Increment minutes to 27
            end else if (mm == 8'b00011011) begin // 27 in BCD
                mm <= 8'b00011100; // Increment minutes to 28
            end else if (mm == 8'b00011100) begin // 28 in BCD
                mm <= 8'b00011101; // Increment minutes to 29
            end else if (mm == 8'b00011101) begin // 29 in BCD
                mm <= 8'b00011110; // Increment minutes to 30
            end else if (mm == 8'b00011110) begin // 30 in BCD
                mm <= 8'b00011111; // Increment minutes to 31
            end else if (mm == 8'b00011111) begin // 31 in BCD
                mm <= 8'b00100000; // Increment minutes to 32
            end else if (mm == 8'b00100000) begin // 32 in BCD
                mm <= 8'b00100001; // Increment minutes to 33
            end else if (mm == 8'b00100001) begin // 33 in BCD
                mm <= 8'b00100010; // Increment minutes to 34
            end else if (mm == 8'b00100010) begin // 34 in BCD
                mm <= 8'b00100011; // Increment minutes to 35
            end else if (mm == 8'b00100011) begin // 35 in BCD
                mm <= 8'b00100100; // Increment minutes to 36
            end else if (mm == 8'b00100100) begin // 36 in BCD
                mm <= 8'b00100101; // Increment minutes to 37
            end else if (mm == 8'b00100101) begin // 37 in BCD
                mm <= 8'b00100110; // Increment minutes to 38
            end else if (mm == 8'b00100110) begin // 38 in BCD
                mm <= 8'b00100111; // Increment minutes to 39
            end else if (mm == 8'b00100111) begin // 39 in BCD
                mm <= 8'b00101000; // Increment minutes to 40
            end else if (mm == 8'b00101000) begin // 40 in BCD
                mm <= 8'b00101001; // Increment minutes to 41
            end else if (mm == 8'b00101001) begin // 41 in BCD
                mm <= 8'b00101010; // Increment minutes to 42
            end else if (mm == 8'b00101010) begin // 42 in BCD
                mm <= 8'b00101011; // Increment minutes to 43
            end else if (mm == 8'b00101011) begin // 43 in BCD
                mm <= 8'b00101100; // Increment minutes to 44
            end else if (mm == 8'b00101100) begin // 44 in BCD
                mm <= 8'b00101101; // Increment minutes to 45
            end else if (mm == 8'b00101101) begin // 45 in BCD
                mm <= 8'b00101110; // Increment minutes to 46
            end else if (mm == 8'b00101110) begin // 46 in BCD
                mm <= 8'b00101111; // Increment minutes to 47
            end else if (mm == 8'b00101111) begin // 47 in BCD
                mm <= 8'b00110000; // Increment minutes to 48
            end else if (mm == 8'b00110000) begin // 48 in BCD
                mm <= 8'b00110001; // Increment minutes to 49
            end else if (mm == 8'b00110001) begin // 49 in BCD
                mm <= 8'b00110010; // Increment minutes to 50
            end else if (mm == 8'b00110010) begin // 50 in BCD
                mm <= 8'b00110011; // Increment minutes to 51
            end else if (mm == 8'b00110011) begin // 51 in BCD
                mm <= 8'b00110100; // Increment minutes to 52
            end else if (mm == 8'b00110100) begin // 52 in BCD
                mm <= 8'b00110101; // Increment minutes to 53
            end else if (mm == 8'b00110101) begin // 53 in BCD
                mm <= 8'b00110110; // Increment minutes to 54
            end else if (mm == 8'b00110110) begin // 54 in BCD
                mm <= 8'b00110111; // Increment minutes to 55
            end else if (mm == 8'b00110111) begin // 55 in BCD
                mm <= 8'b00111000; // Increment minutes to 56
            end else if (mm == 8'b00111000) begin // 56 in BCD
                mm <= 8'b00111001; // Increment minutes to 57
            end else if (mm == 8'b00111001) begin // 57 in BCD
                mm <= 8'b00111010; // Increment minutes to 58
            end else if (mm == 8'b00111010) begin // 58 in BCD
                mm <= 8'b00111011; // Increment minutes to 59
            end else if (mm == 8'b00111011) begin // 59 in BCD
                mm <= 8'b00000000; // Wrap around to 0
            end else begin
                mm <= mm + 1; // Increment minutes
            end
            ss <= 8'b00000000; // Reset seconds
        end else if (ss == 8'b01010101) begin // 59 in BCD
            ss <= 8'b00000000; // Reset seconds
            mm <= mm + 1; // Increment minutes
        end else begin
            ss <= ss + 1; // Increment seconds
        end
    end
end

always @(posedge clk) begin
    if (reset) begin
        pm <= 1'b0; // Reset AM/PM to AM
    end else if ((hh == 8'b00010010 || hh == 8'b00010011 || hh == 8'b00010100 || 
                 hh == 8'b00010101 || hh == 8'b00010110 || hh == 8'b00010111 || 
                 hh == 8'b00011000 || hh == 8'b00011001 || hh == 8'b00011010 || 
                 hh == 8'b00011011 || hh == 8'b00011100 || hh == 8'b00011101)) begin
        pm <= 1'b0; // AM
    end else begin
        pm <= 1'b1; // PM
    end
end

endmodule