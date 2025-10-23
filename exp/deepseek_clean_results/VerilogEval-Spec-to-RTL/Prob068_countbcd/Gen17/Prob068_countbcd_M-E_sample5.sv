module TopModule (
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

    // Digit registers with synchronous reset
    reg [3:0] ones = 4'd0;
    reg [3:0] tens = 4'd0;
    reg [3:0] hundreds = 4'd0;
    reg [3:0] thousands = 4'd0;
    
    // Pipeline registers for enable signals
    reg en_tens = 1'b0;
    reg en_hundreds = 1'b0;
    reg en_thousands = 1'b0;
    
    // Lookahead signals
    wire ones_will_roll = (ones == 4'd8);
    wire tens_will_roll = (tens == 4'd9) && ones_will_roll;
    wire hundreds_will_roll = (hundreds == 4'd9) && tens_will_roll;
    
    // Output assignments
    assign q = {thousands, hundreds, tens, ones};
    assign ena = {en_thousands, en_hundreds, en_tens};
    
    always @(posedge clk) begin
        if (reset) begin
            // Reset all digits
            ones <= 4'd0;
            tens <= 4'd0;
            hundreds <= 4'd0;
            thousands <= 4'd0;
            
            // Reset enable pipeline
            en_tens <= 1'b0;
            en_hundreds <= 1'b0;
            en_thousands <= 1'b0;
        end else begin
            // Always increment ones digit
            ones <= (ones == 4'd9) ? 4'd0 : ones + 4'd1;
            
            // Pipeline the enable signals with lookahead
            en_tens <= (ones == 4'd9);
            en_hundreds <= tens_will_roll;
            en_thousands <= hundreds_will_roll;
            
            // Conditionally increment higher digits
            if (en_tens) begin
                tens <= (tens == 4'd9) ? 4'd0 : tens + 4'd1;
            end
            
            if (en_hundreds) begin
                hundreds <= (hundreds == 4'd9) ? 4'd0 : hundreds + 4'd1;
            end
            
            if (en_thousands) begin
                thousands <= (thousands == 4'd9) ? 4'd0 : thousands + 4'd1;
            end
        end
    end

endmodule