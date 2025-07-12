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
    
    assign ena[0] = (ones == 4'd9);
    assign ena[1] = (ones == 4'd9) & (tens == 4'd9);
    assign ena[2] = (ones == 4'd9) & (tens == 4'd9) & (hundreds == 4'd9);
    assign q = {thousands, hundreds, tens, ones};
    
    always @(posedge clk) begin
        if (reset) begin
            {thousands, hundreds, tens, ones} <= 16'd0;
        end
        else begin
            // Update ones digit
            ones <= (ones == 4'd9) ? 4'd0 : ones + 4'd1;
            
            // Update tens digit if needed
            if (ena[0])
                tens <= (tens == 4'd9) ? 4'd0 : tens + 4'd1;
            
            // Update hundreds digit if needed
            if (ena[1])
                hundreds <= (hundreds == 4'd9) ? 4'd0 : hundreds + 4'd1;
            
            // Update thousands digit if needed
            if (ena[2])
                thousands <= (thousands == 4'd9) ? 4'd0 : thousands + 4'd1;
        end
    end

endmodule