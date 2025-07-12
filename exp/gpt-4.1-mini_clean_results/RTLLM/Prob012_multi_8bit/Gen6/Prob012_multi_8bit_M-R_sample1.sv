module multi_8bit (
    input  wire [7:0] A,
    input  wire [7:0] B,
    output wire [15:0] product
);

    // Function to calculate product by summing shifted multiplicand according to multiplier bits
    function [15:0] shift_add_mul;
        input [7:0] multiplicand;
        input [7:0] multiplier;
        integer i;
        begin
            shift_add_mul = 16'b0;
            for (i = 0; i < 8; i = i + 1) begin
                if (multiplier[i])
                    shift_add_mul = shift_add_mul + (multiplicand << i);
            end
        end
    endfunction

    assign product = shift_add_mul(A, B);

endmodule