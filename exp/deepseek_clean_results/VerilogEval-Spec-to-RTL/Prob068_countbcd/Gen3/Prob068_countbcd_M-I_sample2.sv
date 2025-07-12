module TopModule (
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

    reg [3:0] ones;
    reg [3:0] tens;
    reg [3:0] hundreds;
    reg [3:0] thousands;
    
    // Shared comparison signals
    wire ones_max = (ones == 4'd9);
    wire tens_max = (tens == 4'd9);
    wire hundreds_max = (hundreds == 4'd9);
    
    assign q = {thousands, hundreds, tens, ones};
    
    // Optimized parallel enable logic
    assign ena[0] = ones_max;                      // tens enable
    assign ena[1] = ones_max & tens_max;           // hundreds enable
    assign ena[2] = ones_max & tens_max & hundreds_max; // thousands enable
    
    // Clock gating signals
    wire tens_inc = ena[0] & ~reset;
    wire hundreds_inc = ena[1] & ~reset;
    wire thousands_inc = ena[2] & ~reset;
    
    always @(posedge clk) begin
        if (reset) begin
            ones <= 4'd0;
            tens <= 4'd0;
            hundreds <= 4'd0;
            thousands <= 4'd0;
        end
        else begin
            // Ones digit - always increments
            ones <= (ones == 4'd9) ? 4'd0 : ones + 4'd1;
            
            // Tens digit - increments only when enabled
            if (tens_inc) begin
                tens <= (tens == 4'd9) ? 4'd0 : tens + 4'd1;
            end
            
            // Hundreds digit - increments only when enabled
            if (hundreds_inc) begin
                hundreds <= (hundreds == 4'd9) ? 4'd0 : hundreds + 4'd1;
            end
            
            // Thousands digit - increments only when enabled
            if (thousands_inc) begin
                thousands <= (thousands == 4'd9) ? 4'd0 : thousands + 4'd1;
            end
        end
    end

endmodule