module TopModule (
    input  wire       clk,
    input  wire       reset,
    output reg [9:0]  q
);

    // BCD digit registers (4 bits each, only values 0-9 valid)
    reg [3:0] units;
    reg [3:0] tens;
    reg [3:0] hundreds;

    // Helper function to convert BCD digits to binary number (0-999)
    // q = hundreds*100 + tens*10 + units
    // Implement multiplication by constants with shifts and adds
    wire [9:0] hundreds_times_100 = (hundreds * 7'd100); // max 9*100=900 fits in 10 bits
    wire [9:0] tens_times_10      = (tens * 5'd10);      // max 9*10=90 fits in 7 bits

    always @(posedge clk) begin
        if (reset) begin
            units    <= 4'd0;
            tens     <= 4'd0;
            hundreds <= 4'd0;
            q        <= 10'd0;
        end else begin
            // Increment units digit
            if (units == 4'd9) begin
                units <= 4'd0;

                // Increment tens digit
                if (tens == 4'd9) begin
                    tens <= 4'd0;

                    // Increment hundreds digit
                    if (hundreds == 4'd9) begin
                        // Reached 999, roll over to zero
                        hundreds <= 4'd0;
                    end else begin
                        hundreds <= hundreds + 4'd1;
                    end
                end else begin
                    tens <= tens + 4'd1;
                end
            end else begin
                units <= units + 4'd1;
            end

            // Combine digits into binary output
            q <= hundreds_times_100 + tens_times_10 + units;
        end
    end

endmodule