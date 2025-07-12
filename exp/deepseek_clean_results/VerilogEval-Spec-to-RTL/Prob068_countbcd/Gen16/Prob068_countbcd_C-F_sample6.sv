module TopModule (
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

    reg [3:0] ones, tens, hundreds, thousands;
    
    // Parallel overflow detection
    wire ones_overflow = (ones == 4'd9);
    wire tens_overflow = (tens == 4'd9);
    wire hundreds_overflow = (hundreds == 4'd9);
    
    // Parallel enable generation
    assign ena[0] = ones_overflow;
    assign ena[1] = ones_overflow & tens_overflow;
    assign ena[2] = ones_overflow & tens_overflow & hundreds_overflow;
    
    // Digit update logic (modular style)
    always @(posedge clk) begin
        if (reset) begin
            ones <= 4'd0;
            tens <= 4'd0;
            hundreds <= 4'd0;
            thousands <= 4'd0;
        end else begin
            // Ones digit (always increments)
            ones <= (ones_overflow) ? 4'd0 : (ones + 1'b1);
            
            // Tens digit (increments on ones overflow)
            tens <= (ena[0]) ? ((tens_overflow) ? 4'd0 : (tens + 1'b1)) : tens;
            
            // Hundreds digit (increments on tens overflow)
            hundreds <= (ena[1]) ? ((hundreds_overflow) ? 4'd0 : (hundreds + 1'b1)) : hundreds;
            
            // Thousands digit (increments on hundreds overflow)
            thousands <= (ena[2]) ? ((thousands == 4'd9) ? 4'd0 : (thousands + 1'b1)) : thousands;
        end
    end

    assign q = {thousands, hundreds, tens, ones};

endmodule