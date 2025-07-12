module multi_8bit (
    input  wire [7:0] A,
    input  wire [7:0] B,
    output wire [15:0] product
);

    // Function to compute the product using shift-and-add method
    function [15:0] shift_add_mult;
        input [7:0] multiplicand;
        input [7:0] multiplier;
        integer i;
        reg [15:0] result;
    begin
        result = 16'b0;
        for (i = 0; i < 8; i = i + 1) begin
            if (multiplier[i])
                result = result + (multiplicand << i);
        end
        shift_add_mult = result;
    end
    endfunction

    // Assign product to the function result
    assign product = shift_add_mult(A, B);

endmodule