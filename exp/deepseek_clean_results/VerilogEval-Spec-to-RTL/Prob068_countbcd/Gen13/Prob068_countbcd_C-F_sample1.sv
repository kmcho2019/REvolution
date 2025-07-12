module TopModule (
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

    reg [3:0] ones, tens, hundreds, thousands;
    
    // Enable signals (optimized parallel computation)
    assign ena[0] = (ones == 4'd9);                     // Tens enable
    assign ena[1] = (ones == 4'd9) && (tens == 4'd9);   // Hundreds enable
    assign ena[2] = (ones == 4'd9) && (tens == 4'd9) && (hundreds == 4'd9); // Thousands enable
    
    always @(posedge clk) begin
        if (reset) begin
            ones <= 4'd0;
            tens <= 4'd0;
            hundreds <= 4'd0;
            thousands <= 4'd0;
        end else begin
            // Ones digit always increments
            ones <= (ones == 4'd9) ? 4'd0 : ones + 1'b1;
            
            // Tens digit increments when ones overflows
            if (ena[0]) begin
                tens <= (tens == 4'd9) ? 4'd0 : tens + 1'b1;
            end
            
            // Hundreds digit increments when tens overflows
            if (ena[1]) begin
                hundreds <= (hundreds == 4'd9) ? 4'd0 : hundreds + 1'b1;
            end
            
            // Thousands digit increments when hundreds overflows
            if (ena[2]) begin
                thousands <= (thousands == 4'd9) ? 4'd0 : thousands + 1'b1;
            end
        end
    end

    assign q = {thousands, hundreds, tens, ones};

endmodule