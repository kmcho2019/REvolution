module TopModule (
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

    reg [3:0] ones, tens, hundreds, thousands;
    
    // Internal enables
    wire ones_ena = 1'b1;  // Always enabled
    wire tens_ena = (ones == 4'd9);
    wire hundreds_ena = (ones == 4'd9) & (tens == 4'd9);
    wire thousands_ena = (ones == 4'd9) & (tens == 4'd9) & (hundreds == 4'd9);
    
    // Output enables
    assign ena[0] = tens_ena;
    assign ena[1] = hundreds_ena;
    assign ena[2] = thousands_ena;
    
    always @(posedge clk) begin
        if (reset) begin
            ones <= 4'd0;
            tens <= 4'd0;
            hundreds <= 4'd0;
            thousands <= 4'd0;
        end else begin
            // Ones digit (always increments)
            ones <= (ones_ena) ? ((ones == 4'd9) ? 4'd0 : ones + 4'd1) : ones;
            
            // Tens digit (increments when ones rolls over)
            tens <= (tens_ena) ? ((tens == 4'd9) ? 4'd0 : tens + 4'd1) : tens;
            
            // Hundreds digit (increments when tens rolls over)
            hundreds <= (hundreds_ena) ? ((hundreds == 4'd9) ? 4'd0 : hundreds + 4'd1) : hundreds;
            
            // Thousands digit (increments when hundreds rolls over)
            thousands <= (thousands_ena) ? ((thousands == 4'd9) ? 4'd0 : thousands + 4'd1) : thousands;
        end
    end
    
    // Output concatenation
    assign q = {thousands, hundreds, tens, ones};

endmodule