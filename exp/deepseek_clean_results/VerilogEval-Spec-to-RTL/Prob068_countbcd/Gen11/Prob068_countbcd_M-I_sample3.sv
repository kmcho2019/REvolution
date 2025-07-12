module TopModule (
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

    reg [3:0] ones, tens, hundreds, thousands;
    reg ones_overflow, tens_overflow, hundreds_overflow;
    
    // Registered overflow signals (breaks critical path)
    always @(posedge clk) begin
        ones_overflow <= (ones == 4'd9);
        tens_overflow <= (tens == 4'd9);
        hundreds_overflow <= (hundreds == 4'd9);
    end
    
    // Enable signals (simplified with registered overflows)
    assign ena[0] = ones_overflow;
    assign ena[1] = ones_overflow & tens_overflow;
    assign ena[2] = ones_overflow & tens_overflow & hundreds_overflow;
    
    // Digit update logic (simplified without masking)
    always @(posedge clk) begin
        if (reset) begin
            ones <= 4'd0;
            tens <= 4'd0;
            hundreds <= 4'd0;
            thousands <= 4'd0;
        end else begin
            // Ones digit
            if (ones == 4'd9) ones <= 4'd0;
            else ones <= ones + 1'b1;
            
            // Tens digit
            if (ena[0]) begin
                if (tens == 4'd9) tens <= 4'd0;
                else tens <= tens + 1'b1;
            end
            
            // Hundreds digit
            if (ena[1]) begin
                if (hundreds == 4'd9) hundreds <= 4'd0;
                else hundreds <= hundreds + 1'b1;
            end
            
            // Thousands digit
            if (ena[2]) begin
                if (thousands == 4'd9) thousands <= 4'd0;
                else thousands <= thousands + 1'b1;
            end
        end
    end

    assign q = {thousands, hundreds, tens, ones};

endmodule