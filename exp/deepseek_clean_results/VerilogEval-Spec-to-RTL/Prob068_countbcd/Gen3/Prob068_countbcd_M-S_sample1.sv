module TopModule (
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

    reg [3:0] ones = 0;
    reg [3:0] tens = 0;
    reg [3:0] hundreds = 0;
    reg [3:0] thousands = 0;
    
    assign q = {thousands, hundreds, tens, ones};
    
    always @(posedge clk) begin
        if (reset) begin
            ones <= 0;
            tens <= 0;
            hundreds <= 0;
            thousands <= 0;
            ena <= 0;
        end
        else begin
            // Default enable signals to 0
            ena <= 0;
            
            // Handle ones digit
            if (ones == 9) begin
                ones <= 0;
                ena[0] <= 1;
                
                // Handle tens digit
                if (tens == 9) begin
                    tens <= 0;
                    ena[1] <= 1;
                    
                    // Handle hundreds digit
                    if (hundreds == 9) begin
                        hundreds <= 0;
                        ena[2] <= 1;
                        
                        // Handle thousands digit
                        if (thousands == 9)
                            thousands <= 0;
                        else
                            thousands <= thousands + 1;
                    end
                    else begin
                        hundreds <= hundreds + 1;
                    end
                end
                else begin
                    tens <= tens + 1;
                end
            end
            else begin
                ones <= ones + 1;
            end
        end
    end

endmodule