module TopModule (
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

    reg [3:0] digit_ones;
    reg [3:0] digit_tens;
    reg [3:0] digit_hundreds;
    reg [3:0] digit_thousands;
    
    // Enable signals for upper digits
    assign ena[0] = (digit_ones == 4'd9);       // Enable tens when ones is 9
    assign ena[1] = (digit_tens == 4'd9) && ena[0]; // Enable hundreds when tens is 9 and about to roll
    assign ena[2] = (digit_hundreds == 4'd9) && ena[1]; // Enable thousands when hundreds is 9 and about to roll
    
    // Combine digits into output
    assign q = {digit_thousands, digit_hundreds, digit_tens, digit_ones};
    
    always @(posedge clk) begin
        if (reset) begin
            digit_ones <= 4'd0;
            digit_tens <= 4'd0;
            digit_hundreds <= 4'd0;
            digit_thousands <= 4'd0;
        end else begin
            // Always increment ones digit
            if (digit_ones == 4'd9) begin
                digit_ones <= 4'd0;
            end else begin
                digit_ones <= digit_ones + 4'd1;
            end
            
            // Increment tens digit when ones rolls over
            if (ena[0]) begin
                if (digit_tens == 4'd9) begin
                    digit_tens <= 4'd0;
                end else begin
                    digit_tens <= digit_tens + 4'd1;
                end
            end
            
            // Increment hundreds digit when tens rolls over
            if (ena[1]) begin
                if (digit_hundreds == 4'd9) begin
                    digit_hundreds <= 4'd0;
                end else begin
                    digit_hundreds <= digit_hundreds + 4'd1;
                end
            end
            
            // Increment thousands digit when hundreds rolls over
            if (ena[2]) begin
                if (digit_thousands == 4'd9) begin
                    digit_thousands <= 4'd0;
                end else begin
                    digit_thousands <= digit_thousands + 4'd1;
                end
            end
        end
    end

endmodule