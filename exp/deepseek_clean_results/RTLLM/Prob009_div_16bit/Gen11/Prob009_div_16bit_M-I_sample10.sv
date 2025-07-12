module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output [15:0] result,
    output [15:0] odd
);

    wire [16:0] final_remainder;
    wire [15:0] quotient;
    
    // Combinational division logic
    function [16:0] divide;
        input [15:0] dividend;
        input [7:0] divisor;
        reg [16:0] remainder;
        reg [15:0] quot;
        integer i;
        
        begin
            remainder = 17'b0;
            for (i = 15; i >= 0; i = i - 1) begin
                remainder = {remainder[15:0], dividend[i]};
                if (remainder >= {1'b0, divisor}) begin
                    remainder = remainder - {1'b0, divisor};
                    quot[i] = 1'b1;
                end else begin
                    quot[i] = 1'b0;
                end
            end
            divide = {quot, remainder[15:0]};
        end
    endfunction
    
    // Perform division
    assign {result, final_remainder} = divide(A, B);
    assign odd = final_remainder[15:0];

endmodule