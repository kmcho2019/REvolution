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
    
    // Optimized enable logic
    wire ones_max = (ones == 4'd9);
    wire tens_max = (tens == 4'd9);
    wire hundreds_max = (hundreds == 4'd9);
    
    assign ena[0] = ones_max;                     // Tens enable
    assign ena[1] = ones_max & tens_max;           // Hundreds enable
    assign ena[2] = ena[1] & hundreds_max;         // Thousands enable
    
    assign q = {thousands, hundreds, tens, ones};
    
    always @(posedge clk) begin
        if (reset) begin
            ones <= 4'd0;
            tens <= 4'd0;
            hundreds <= 4'd0;
            thousands <= 4'd0;
        end
        else begin
            // Ones digit - always increments
            ones <= (ones_max) ? 4'd0 : ones + 4'd1;
            
            // Tens digit - increments when ones rolls over
            if (ena[0]) begin
                tens <= (tens_max) ? 4'd0 : tens + 4'd1;
            end
            
            // Hundreds digit - increments when tens rolls over
            if (ena[1]) begin
                hundreds <= (hundreds_max) ? 4'd0 : hundreds + 4'd1;
            end
            
            // Thousands digit - increments when hundreds rolls over
            if (ena[2]) begin
                thousands <= (thousands == 4'd9) ? 4'd0 : thousands + 4'd1;
            end
        end
    end

endmodule