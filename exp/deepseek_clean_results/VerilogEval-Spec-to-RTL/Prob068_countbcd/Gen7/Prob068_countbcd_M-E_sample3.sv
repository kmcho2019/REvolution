module TopModule (
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

    reg [3:0] ones, tens, hundreds, thousands;
    wire ones_rollover, tens_rollover, hundreds_rollover;
    
    // Rollover conditions (pre-computed)
    assign ones_rollover = (ones == 4'd9);
    assign tens_rollover = (tens == 4'd9);
    assign hundreds_rollover = (hundreds == 4'd9);
    
    // Enable signals
    assign ena[0] = ones_rollover;
    assign ena[1] = ones_rollover & tens_rollover;
    assign ena[2] = ones_rollover & tens_rollover & hundreds_rollover;
    
    // Combined output
    assign q = {thousands, hundreds, tens, ones};
    
    // Independent counters with lookahead increment logic
    always @(posedge clk) begin
        if (reset) begin
            ones <= 4'd0;
            tens <= 4'd0;
            hundreds <= 4'd0;
            thousands <= 4'd0;
        end
        else begin
            // Ones digit - always increments
            ones <= ones_rollover ? 4'd0 : ones + 1;
            
            // Tens digit - increments when ones rolls over
            if (ones_rollover)
                tens <= tens_rollover ? 4'd0 : tens + 1;
            
            // Hundreds digit - increments when both lower digits roll over
            if (ones_rollover & tens_rollover)
                hundreds <= hundreds_rollover ? 4'd0 : hundreds + 1;
            
            // Thousands digit - increments when all lower digits roll over
            if (ones_rollover & tens_rollover & hundreds_rollover)
                thousands <= (thousands == 4'd9) ? 4'd0 : thousands + 1;
        end
    end

endmodule