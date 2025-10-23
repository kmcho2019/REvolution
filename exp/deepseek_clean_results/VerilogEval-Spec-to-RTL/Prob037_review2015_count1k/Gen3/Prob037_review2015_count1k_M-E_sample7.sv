module TopModule (
    input clk,
    input reset,
    output [9:0] q
);

reg [3:0] units;  // 0-9
reg [3:0] tens;   // 0-9
reg [3:0] hundreds; // 0-9

wire units_rollover = (units == 4'd9);
wire tens_rollover = (tens == 4'd9);
wire hundreds_rollover = (hundreds == 4'd9);

always @(posedge clk) begin
    if (reset) begin
        units <= 4'b0;
        tens <= 4'b0;
        hundreds <= 4'b0;
    end
    else begin
        // Units digit
        if (units_rollover)
            units <= 4'b0;
        else
            units <= units + 1'b1;
            
        // Tens digit
        if (units_rollover) begin
            if (tens_rollover)
                tens <= 4'b0;
            else
                tens <= tens + 1'b1;
        end
        
        // Hundreds digit
        if (units_rollover & tens_rollover) begin
            if (hundreds_rollover)
                hundreds <= 4'b0;
            else
                hundreds <= hundreds + 1'b1;
        end
    end
end

// Combine digits to form 10-bit output (hundreds * 100 + tens * 10 + units)
assign q = {hundreds, tens, units};

endmodule