module TopModule (
    input clk,
    input reset,
    output reg [9:0] q
);

    reg [3:0] units;    // 0 to 9
    reg [3:0] tens;     // 0 to 9 (used to count tens digit of decimal number)
    reg [3:0] hundreds; // 0 to 9

    // The counter counts 0 to 999 in decimal by incrementing units, tens, hundreds
    // q = hundreds*100 + tens*10 + units

    // Multiplying by constants using shift-add for output
    wire [9:0] hundreds_val = {6'd0, hundreds} * 10'd100; // hundreds*100
    wire [9:0] tens_val = {6'd0, tens} * 10'd10;         // tens*10
    wire [9:0] units_val = {6'd0, units};

    always @(posedge clk) begin
        if (reset) begin
            units <= 4'd0;
            tens <= 4'd0;
            hundreds <= 4'd0;
            q <= 10'd0;
        end else begin
            // Increment units digit
            if (units == 4'd9) begin
                units <= 4'd0;
                // Increment tens digit
                if (tens == 4'd9) begin
                    tens <= 4'd0;
                    // Increment hundreds digit
                    if (hundreds == 4'd9) begin
                        hundreds <= 4'd0; // wrap to zero after 999
                    end else begin
                        hundreds <= hundreds + 4'd1;
                    end
                end else begin
                    tens <= tens + 4'd1;
                end
            end else begin
                units <= units + 4'd1;
            end

            // Calculate combined output
            // q = hundreds*100 + tens*10 + units
            // Using shifts for multiplication: 100 = 64 + 32 + 4, 10 = 8 + 2
            q <= (hundreds << 6) + (hundreds << 5) + (hundreds << 2)
                 + (tens << 3) + (tens << 1)
                 + units;
        end
    end
endmodule