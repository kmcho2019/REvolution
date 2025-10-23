module TopModule (
    input clk,
    input reset,
    output [9:0] q
);

reg [3:0] units, tens, hundreds;
wire units_rollover = (units == 4'd9);
wire tens_rollover = (tens == 4'd9) & units_rollover;

always @(posedge clk) begin
    if (reset) begin
        units <= 4'b0;
        tens <= 4'b0;
        hundreds <= 4'b0;
    end
    else begin
        // Units counter
        if (units_rollover)
            units <= 4'b0;
        else
            units <= units + 1'b1;
            
        // Tens counter
        if (units_rollover) begin
            if (tens_rollover)
                tens <= 4'b0;
            else
                tens <= tens + 1'b1;
        end
        
        // Hundreds counter
        if (tens_rollover & units_rollover) begin
            if (hundreds == 4'd9)
                hundreds <= 4'b0;
            else
                hundreds <= hundreds + 1'b1;
        end
    end
end

// Combine outputs
assign q = {hundreds, tens, units};

endmodule