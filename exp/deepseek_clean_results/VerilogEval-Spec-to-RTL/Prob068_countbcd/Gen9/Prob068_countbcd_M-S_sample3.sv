module TopModule (
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

    reg [3:0] ones, tens, hundreds, thousands;
    
    // Overflow detection
    wire ones_overflow = (ones == 4'd9);
    wire tens_overflow = (tens == 4'd9);
    wire hundreds_overflow = (hundreds == 4'd9);
    
    // Enable signals
    assign ena[0] = ones_overflow;
    assign ena[1] = (ones_overflow && tens_overflow);
    assign ena[2] = (ones_overflow && tens_overflow && hundreds_overflow);
    
    always @(posedge clk) begin
        if (reset) begin
            ones <= 4'd0;
            tens <= 4'd0;
            hundreds <= 4'd0;
            thousands <= 4'd0;
        end else begin
            // Ones digit always increments
            ones <= ones_overflow ? 4'd0 : ones + 1'b1;
            
            // Tens digit increments when ones overflows
            if (ones_overflow)
                tens <= tens_overflow ? 4'd0 : tens + 1'b1;
            
            // Hundreds digit increments when both lower digits overflow
            if (ones_overflow && tens_overflow)
                hundreds <= hundreds_overflow ? 4'd0 : hundreds + 1'b1;
            
            // Thousands digit increments when all lower digits overflow
            if (ones_overflow && tens_overflow && hundreds_overflow)
                thousands <= (thousands == 4'd9) ? 4'd0 : thousands + 1'b1;
        end
    end

    assign q = {thousands, hundreds, tens, ones};

endmodule