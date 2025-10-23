module TopModule (
    input clk,
    input reset,
    output [9:0] q
);

reg [3:0] units;
reg [3:0] tens;
reg [2:0] hundreds;
wire units_tc = (units == 9);
wire tens_tc = (tens == 9);

always @(posedge clk) begin
    if (reset) begin
        units <= 0;
        tens <= 0;
        hundreds <= 0;
    end
    else begin
        // Units counter (0-9)
        units <= units_tc ? 0 : units + 1;
        
        // Tens counter (0-9)
        if (units_tc)
            tens <= tens_tc ? 0 : tens + 1;
            
        // Hundreds counter (0-9)
        if (units_tc & tens_tc)
            hundreds <= (hundreds == 9) ? 0 : hundreds + 1;
    end
end

// Combine outputs
assign q = {hundreds, tens, units};

endmodule