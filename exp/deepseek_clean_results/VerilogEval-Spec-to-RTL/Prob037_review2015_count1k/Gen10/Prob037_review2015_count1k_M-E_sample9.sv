module TopModule (
    input clk,
    input reset,
    output [9:0] q
);

reg [3:0] units;    // 0-9
reg [3:0] tens;     // 0-9
reg [3:0] hundreds; // 0-9

// BCD counter logic
always @(posedge clk) begin
    if (reset) begin
        units <= 4'd0;
        tens <= 4'd0;
        hundreds <= 4'd0;
    end else begin
        // Increment units digit
        if (units == 4'd9) begin
            units <= 4'd0;
            // Increment tens digit when units wraps
            if (tens == 4'd9) begin
                tens <= 4'd0;
                // Increment hundreds when tens wraps
                if (hundreds == 4'd9) begin
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
    end
end

// Combine digits to form 10-bit output
assign q = {hundreds, tens, units};

endmodule