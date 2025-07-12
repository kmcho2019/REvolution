module TopModule (
    input clk,
    input reset,
    output [9:0] q
);

reg [3:0] ones;  // counts 0-9
reg [3:0] tens;  // counts 0-9
reg [3:0] hundreds; // counts 0-9

always @(posedge clk) begin
    if (reset) begin
        ones <= 4'b0;
        tens <= 4'b0;
        hundreds <= 4'b0;
    end
    else begin
        // Ones digit
        if (ones == 4'd9) begin
            ones <= 4'b0;
            // Tens digit
            if (tens == 4'd9) begin
                tens <= 4'b0;
                // Hundreds digit
                if (hundreds == 4'd9) begin
                    hundreds <= 4'b0;
                end
                else begin
                    hundreds <= hundreds + 1'b1;
                end
            end
            else begin
                tens <= tens + 1'b1;
            end
        end
        else begin
            ones <= ones + 1'b1;
        end
    end
end

// Combine digits to form 10-bit output
assign q = hundreds * 7'd100 + tens * 7'd10 + ones;

endmodule