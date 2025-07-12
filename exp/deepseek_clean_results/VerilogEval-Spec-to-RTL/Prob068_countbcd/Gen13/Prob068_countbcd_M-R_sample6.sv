module TopModule (
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

    reg [3:0] ones, tens, hundreds, thousands;
    
    // Combinational enable logic
    wire ones_overflow = (ones == 4'd9);
    wire tens_overflow = (tens == 4'd9);
    wire hundreds_overflow = (hundreds == 4'd9);
    
    assign ena[0] = ones_overflow;
    assign ena[1] = ones_overflow && tens_overflow;
    assign ena[2] = ones_overflow && tens_overflow && hundreds_overflow;
    
    // Synchronous counter update
    always @(posedge clk) begin
        if (reset) begin
            ones <= 4'd0;
            tens <= 4'd0;
            hundreds <= 4'd0;
            thousands <= 4'd0;
        end else begin
            // Ones digit (always increments)
            if (ones == 4'd9)
                ones <= 4'd0;
            else
                ones <= ones + 4'd1;
            
            // Tens digit (increments when ones overflows)
            if (ena[0]) begin
                if (tens == 4'd9)
                    tens <= 4'd0;
                else
                    tens <= tens + 4'd1;
            end
            
            // Hundreds digit (increments when tens overflows)
            if (ena[1]) begin
                if (hundreds == 4'd9)
                    hundreds <= 4'd0;
                else
                    hundreds <= hundreds + 4'd1;
            end
            
            // Thousands digit (increments when hundreds overflows)
            if (ena[2]) begin
                if (thousands == 4'd9)
                    thousands <= 4'd0;
                else
                    thousands <= thousands + 4'd1;
            end
        end
    end
    
    // Output assignment
    assign q = {thousands, hundreds, tens, ones};

endmodule