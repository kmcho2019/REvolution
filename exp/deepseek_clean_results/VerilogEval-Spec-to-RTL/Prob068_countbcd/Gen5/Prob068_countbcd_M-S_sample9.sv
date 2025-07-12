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
    
    assign ena[0] = (ones == 9);
    assign ena[1] = (ones == 9) & (tens == 9);
    assign ena[2] = (ones == 9) & (tens == 9) & (hundreds == 9);
    assign q = {thousands, hundreds, tens, ones};
    
    always @(posedge clk) begin
        if (reset) begin
            {thousands, hundreds, tens, ones} <= 0;
        end else begin
            ones <= (ones == 9) ? 0 : ones + 1;
            if (ena[0]) tens <= (tens == 9) ? 0 : tens + 1;
            if (ena[1]) hundreds <= (hundreds == 9) ? 0 : hundreds + 1;
            if (ena[2]) thousands <= (thousands == 9) ? 0 : thousands + 1;
        end
    end

endmodule