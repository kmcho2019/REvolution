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
    if(reset) begin
        hh <= 8'b0001_0010; // 12 in BCD
        mm <= 8'b0000_0000; // 00 in BCD
        ss <= 8'b0000_0000; // 00 in BCD
        pm <= 1'b0; // AM
    end else if(ena) begin
        // Increment seconds
        if(ss == 8'b0101_1000) begin // 59 in BCD
            ss <= 8'b0000_0000; // 00 in BCD
            // Increment minutes
            if(mm == 8'b0101_1000) begin // 59 in BCD
                mm <= 8'b0000_0000; // 00 in BCD
                // Increment hours
                if(hh == 8'b0001_0010) begin // 12 in BCD (AM)
                    hh <= 8'b0001_0010; // 12 in BCD (AM)
                end else if(hh == 8'b0001_1000) begin // 12 in BCD (PM)
                    hh <= 8'b0000_0001; // 01 in BCD (PM)
                end else if(hh >= 8'b0001_1000) begin // greater than 12 in BCD (PM)
                    hh <= hh + 1'b1;
                end else begin
                    hh <= hh + 1'b1;
                end
            end else begin
                mm <= mm + 1'b1;
            end
        end else begin
            ss <= ss + 1'b1;
        end
    end

    // Set pm signal
    if(hh >= 8'b0001_1000 && hh < 8'b0010_0000) begin // greater than or equal to 12 in BCD and less than 20 in BCD
        pm <= 1'b1; // PM
    end else begin
        pm <= 1'b0; // AM
    end
end

endmodule