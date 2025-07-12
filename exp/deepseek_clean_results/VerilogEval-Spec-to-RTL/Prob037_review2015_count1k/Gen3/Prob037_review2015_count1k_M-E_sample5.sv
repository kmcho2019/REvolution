module TopModule (
    input clk,
    input reset,
    output [9:0] q
);

reg [3:0] units, tens, hundreds;
wire units_max = (units == 4'd9);
wire tens_max = (tens == 4'd9);
wire hundreds_max = (hundreds == 4'd9);

always @(posedge clk) begin
    if (reset) begin
        units <= 4'b0;
        tens <= 4'b0;
        hundreds <= 4'b0;
    end
    else begin
        // Units counter (0-9)
        if (units_max)
            units <= 4'b0;
        else
            units <= units + 1'b1;
            
        // Tens counter (0-9) - increments every 10 cycles
        if (units_max) begin
            if (tens_max)
                tens <= 4'b0;
            else
                tens <= tens + 1'b1;
        end
        
        // Hundreds counter (0-9) - increments every 100 cycles
        if (units_max & tens_max) begin
            if (hundreds_max)
                hundreds <= 4'b0;
            else
                hundreds <= hundreds + 1'b1;
        end
    end
end

// Combine digits to form 10-bit output
assign q = {hundreds, tens, units};

endmodule