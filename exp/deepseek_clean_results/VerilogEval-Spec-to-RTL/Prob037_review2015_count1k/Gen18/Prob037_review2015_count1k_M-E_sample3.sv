module TopModule (
    input clk,
    input reset,
    output reg [9:0] q
);

reg [3:0] units;
reg [3:0] tens;
reg [3:0] hundreds;

wire units_overflow = (units == 4'd9);
wire tens_overflow = (tens == 4'd9) & units_overflow;
wire terminal_count = (hundreds == 4'd9) & tens_overflow;

always @(posedge clk) begin
    if (reset) begin
        units <= 4'b0;
        tens <= 4'b0;
        hundreds <= 4'b0;
    end
    else begin
        // Units digit
        if (units_overflow)
            units <= 4'b0;
        else
            units <= units + 1'b1;
            
        // Tens digit
        if (units_overflow) begin
            if (tens_overflow)
                tens <= 4'b0;
            else
                tens <= tens + 1'b1;
        end
        
        // Hundreds digit
        if (tens_overflow & units_overflow) begin
            if (terminal_count)
                hundreds <= 4'b0;
            else
                hundreds <= hundreds + 1'b1;
        end
    end
    
    // Combine BCD digits to form output
    q <= {hundreds, tens, units};
end

endmodule