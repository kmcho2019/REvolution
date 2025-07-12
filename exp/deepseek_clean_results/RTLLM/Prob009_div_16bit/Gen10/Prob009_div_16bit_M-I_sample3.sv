module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output [15:0] result,
    output [7:0] odd
);

    wire [8:0] final_remainder;
    wire [15:0] quotient;
    
    // Division logic using a single propagating remainder
    assign {final_remainder, quotient} = divide(A, B);
    
    assign result = quotient;
    assign odd = final_remainder[7:0];
    
    function [24:0] divide;  // [8:0] remainder + [15:0] quotient
        input [15:0] dividend;
        input [7:0] divisor;
        
        reg [8:0] rem;
        reg [15:0] quot;
        integer i;
        
        begin
            rem = 9'b0;
            for (i = 15; i >= 0; i = i - 1) begin
                rem = {rem[7:0], dividend[i]};
                quot[i] = (rem >= divisor);
                if (quot[i])
                    rem = rem - divisor;
            end
            divide = {rem, quot};
        end
    endfunction

endmodule