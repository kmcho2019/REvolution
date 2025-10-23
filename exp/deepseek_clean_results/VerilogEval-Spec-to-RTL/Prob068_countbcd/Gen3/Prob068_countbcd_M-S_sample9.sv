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
    
    // Simplified enable logic
    assign ena[0] = (ones == 4'd9);
    assign ena[1] = (tens == 4'd9);
    assign ena[2] = (hundreds == 4'd9);
    
    assign q = {thousands, hundreds, tens, ones};
    
    always @(posedge clk) begin
        if (reset) begin
            {thousands, hundreds, tens, ones} <= 16'd0;
        end
        else begin
            // Ones digit always increments
            ones <= (ones == 4'd9) ? 4'd0 : ones + 4'd1;
            
            // Tens digit increments when ones rolls over
            if (ena[0])
                tens <= (tens == 4'd9) ? 4'd0 : tens + 4'd1;
            
            // Hundreds digit increments when tens rolls over
            if (ena[1])
                hundreds <= (hundreds == 4'd9) ? 4'd0 : hundreds + 4'd1;
            
            // Thousands digit increments when hundreds rolls over
            if (ena[2])
                thousands <= (thousands == 4'd9) ? 4'd0 : thousands + 4'd1;
        end
    end

endmodule