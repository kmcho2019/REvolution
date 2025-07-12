module TopModule (
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

    reg [3:0] ones, tens, hundreds, thousands;
    
    // Current digit values
    assign q = {thousands, hundreds, tens, ones};
    
    // Next digit values
    wire [3:0] next_ones = (ones == 4'd9) ? 4'd0 : ones + 4'd1;
    wire [3:0] next_tens = (tens == 4'd9) ? 4'd0 : tens + 4'd1;
    wire [3:0] next_hundreds = (hundreds == 4'd9) ? 4'd0 : hundreds + 4'd1;
    wire [3:0] next_thousands = (thousands == 4'd9) ? 4'd0 : thousands + 4'd1;
    
    // Enable conditions (lookahead)
    assign ena[0] = (ones == 4'd9);
    assign ena[1] = (ones == 4'd9) && (tens == 4'd9);
    assign ena[2] = (ones == 4'd9) && (tens == 4'd9) && (hundreds == 4'd9);
    
    // Digit update logic
    always @(posedge clk) begin
        if (reset) begin
            ones <= 4'd0;
            tens <= 4'd0;
            hundreds <= 4'd0;
            thousands <= 4'd0;
        end else begin
            // Ones digit always increments
            ones <= next_ones;
            
            // Tens digit increments when ones rolls over
            tens <= ena[0] ? next_tens : tens;
            
            // Hundreds digit increments when tens rolls over
            hundreds <= ena[1] ? next_hundreds : hundreds;
            
            // Thousands digit increments when hundreds rolls over
            thousands <= ena[2] ? next_thousands : thousands;
        end
    end

endmodule