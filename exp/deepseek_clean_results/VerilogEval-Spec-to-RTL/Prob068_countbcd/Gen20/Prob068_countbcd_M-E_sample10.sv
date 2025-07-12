module TopModule (
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

    reg [3:0] ones, tens, hundreds, thousands;
    
    // Current digit values
    wire ones_rollover = (ones == 4'd9);
    wire tens_rollover = (tens == 4'd9);
    wire hundreds_rollover = (hundreds == 4'd9);
    
    // Enable conditions (computed in parallel)
    assign ena[0] = ones_rollover;
    assign ena[1] = ones_rollover & tens_rollover;
    assign ena[2] = ones_rollover & tens_rollover & hundreds_rollover;
    
    // Digit update logic (all synchronous)
    always @(posedge clk) begin
        if (reset) begin
            ones <= 4'd0;
            tens <= 4'd0;
            hundreds <= 4'd0;
            thousands <= 4'd0;
        end else begin
            // Ones digit always increments
            ones <= (ones_rollover) ? 4'd0 : ones + 4'd1;
            
            // Tens digit increments when ones rolls over
            tens <= (ena[0]) ? 
                   (tens_rollover ? 4'd0 : tens + 4'd1) : tens;
                   
            // Hundreds digit increments when both lower digits roll over
            hundreds <= (ena[1]) ? 
                       (hundreds_rollover ? 4'd0 : hundreds + 4'd1) : hundreds;
                       
            // Thousands digit increments when all lower digits roll over
            thousands <= (ena[2]) ? 
                        ((thousands == 4'd9) ? 4'd0 : thousands + 4'd1) : thousands;
        end
    end
    
    // Output concatenation
    assign q = {thousands, hundreds, tens, ones};

endmodule