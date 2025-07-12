module TopModule (
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

    reg [3:0] ones, tens, hundreds, thousands;
    
    // Digit values assignment
    assign q = {thousands, hundreds, tens, ones};
    
    // Enable logic - parallel computation avoids ripple delay
    assign ena[0] = (ones == 4'd9);
    assign ena[1] = (ones == 4'd9) && (tens == 4'd9);
    assign ena[2] = (ones == 4'd9) && (tens == 4'd9) && (hundreds == 4'd9);
    
    always @(posedge clk) begin
        if (reset) begin
            // Reset all digits
            ones <= 4'd0;
            tens <= 4'd0;
            hundreds <= 4'd0;
            thousands <= 4'd0;
        end else begin
            // Always increment ones digit
            ones <= (ones == 4'd9) ? 4'd0 : ones + 4'd1;
            
            // Conditional increment for higher digits
            if (ena[0]) begin
                tens <= (tens == 4'd9) ? 4'd0 : tens + 4'd1;
            end
            
            if (ena[1]) begin
                hundreds <= (hundreds == 4'd9) ? 4'd0 : hundreds + 4'd1;
            end
            
            if (ena[2]) begin
                thousands <= (thousands == 4'd9) ? 4'd0 : thousands + 4'd1;
            end
        end
    end

endmodule