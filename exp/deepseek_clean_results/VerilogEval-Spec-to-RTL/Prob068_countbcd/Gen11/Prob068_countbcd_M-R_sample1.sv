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
    
    wire ones_overflow = (ones == 4'd9);
    wire tens_overflow = (tens == 4'd9) & ones_overflow;
    wire hundreds_overflow = (hundreds == 4'd9) & tens_overflow;
    
    assign ena[0] = ones_overflow;
    assign ena[1] = tens_overflow;
    assign ena[2] = hundreds_overflow;
    
    assign q = {thousands, hundreds, tens, ones};
    
    always @(posedge clk) begin
        if (reset) begin
            ones <= 4'd0;
            tens <= 4'd0;
            hundreds <= 4'd0;
            thousands <= 4'd0;
        end else begin
            // Ones digit always increments
            ones <= (ones == 4'd9) ? 4'd0 : ones + 1;
            
            // Tens digit increments when ones overflows
            if (ones_overflow)
                tens <= (tens == 4'd9) ? 4'd0 : tens + 1;
            
            // Hundreds digit increments when tens overflows
            if (tens_overflow)
                hundreds <= (hundreds == 4'd9) ? 4'd0 : hundreds + 1;
            
            // Thousands digit increments when hundreds overflows
            if (hundreds_overflow)
                thousands <= (thousands == 4'd9) ? 4'd0 : thousands + 1;
        end
    end

endmodule