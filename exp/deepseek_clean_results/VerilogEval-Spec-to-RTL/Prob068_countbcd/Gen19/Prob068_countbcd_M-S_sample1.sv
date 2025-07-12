module TopModule (
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

    reg [3:0] ones, tens, hundreds, thousands;
    
    // Assign output values
    assign q = {thousands, hundreds, tens, ones};
    
    // Enable signals indicate when each digit is about to roll over
    assign ena[0] = (ones == 4'd9);                  // Ones about to roll over
    assign ena[1] = (ones == 4'd9) && (tens == 4'd9); // Tens about to roll over
    assign ena[2] = (ones == 4'd9) && (tens == 4'd9) && (hundreds == 4'd9); // Hundreds about to roll over
    
    always @(posedge clk) begin
        if (reset) begin
            // Reset all digits to 0
            ones <= 4'd0;
            tens <= 4'd0;
            hundreds <= 4'd0;
            thousands <= 4'd0;
        end else begin
            // Always increment ones digit
            ones <= (ones == 4'd9) ? 4'd0 : ones + 4'd1;
            
            // Increment tens when ones roll over
            if (ones == 4'd9) begin
                tens <= (tens == 4'd9) ? 4'd0 : tens + 4'd1;
            end
            
            // Increment hundreds when both ones and tens roll over
            if ((ones == 4'd9) && (tens == 4'd9)) begin
                hundreds <= (hundreds == 4'd9) ? 4'd0 : hundreds + 4'd1;
            end
            
            // Increment thousands when ones, tens, and hundreds roll over
            if ((ones == 4'd9) && (tens == 4'd9) && (hundreds == 4'd9)) begin
                thousands <= (thousands == 4'd9) ? 4'd0 : thousands + 4'd1;
            end
        end
    end

endmodule