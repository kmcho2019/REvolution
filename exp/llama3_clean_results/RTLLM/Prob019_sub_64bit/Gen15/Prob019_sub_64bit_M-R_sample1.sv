// Refactored version focusing on modularity and SystemVerilog features
module sub_64bit(
    input  wire [63:0] A,  // First 64-bit input operand
    input  wire [63:0] B,  // Second 64-bit input operand
    output wire [63:0] result,  // 64-bit output representing the difference of A and B
    output wire        overflow  // 1-bit output indicating whether an overflow occurred
);

    // Perform binary subtraction of A and B
    wire [63:0] subtraction_result;
    assign subtraction_result = A - B;
    
    // Modular overflow detection logic
    wire overflow detection;
    assign detection = check_overflow(A, B, subtraction_result);
    
    // Assign results
    assign result = subtraction_result;
    assign overflow = detection;

    // Function for overflow detection
    function logic check_overflow(input [63:0] a, input [63:0] b, input [63:0] res);
        // An overflow occurs when a and b have the same sign but the result has a different sign
        check_overflow = (a[63] == b[63] && a[63] != res[63]) ? 1'b1 : 1'b0;
    endfunction

endmodule