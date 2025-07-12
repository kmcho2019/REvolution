module TopModule (
    input clk,
    input reset,
    output [9:0] q
);

reg [3:0] bcd_hundreds;  // 0-9 (hundreds digit)
reg [3:0] bcd_tens;      // 0-9 (tens digit)
reg [3:0] bcd_units;     // 0-9 (units digit)

// BCD counter logic
always @(posedge clk) begin
    if (reset) begin
        bcd_hundreds <= 4'b0;
        bcd_tens <= 4'b0;
        bcd_units <= 4'b0;
    end
    else begin
        // Units digit increment with carry
        if (bcd_units == 4'd9) begin
            bcd_units <= 4'd0;
            // Tens digit increment with carry
            if (bcd_tens == 4'd9) begin
                bcd_tens <= 4'd0;
                // Hundreds digit increment with rollover
                if (bcd_hundreds == 4'd9) begin
                    bcd_hundreds <= 4'd0;
                end
                else begin
                    bcd_hundreds <= bcd_hundreds + 1'b1;
                end
            end
            else begin
                bcd_tens <= bcd_tens + 1'b1;
            end
        end
        else begin
            bcd_units <= bcd_units + 1'b1;
        end
    end
end

// Combine BCD digits to form output (packed BCD format)
assign q = {bcd_hundreds, bcd_tens, bcd_units};

endmodule