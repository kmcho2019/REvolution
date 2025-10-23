// Define a module for a 1-bit full subtractor
module full_subtractor(a, b, borrow_in, difference, borrow_out);
    input a, b, borrow_in;
    output difference, borrow_out;
    
    assign difference = a ^ b ^ borrow_in;
    assign borrow_out = (~a & b) | (borrow_in & (~a ^ b));
endmodule

// Define the comparator_4bit module
module comparator_4bit(A, B, A_greater, A_equal, A_less);
    input [3:0] A;
    input [3:0] B;
    output A_greater, A_equal, A_less;
    
    // Internal signals for the borrow and result of subtraction
    wire borrow_1, borrow_2, borrow_3;
    wire [3:0] result;
    
    // Instantiate the full subtractors
    full_subtractor fs0(A[0], B[0], 1'b0, result[0], borrow_1);
    full_subtractor fs1(A[1], B[1], borrow_1, result[1], borrow_2);
    full_subtractor fs2(A[2], B[2], borrow_2, result[2], borrow_3);
    full_subtractor fs3(A[3], B[3], borrow_3, result[3], );
    
    // Generate the A_greater, A_equal, and A_less outputs
    assign A_greater = ~borrow_3 & (~|result); // A is greater than B if no borrow and result is not zero
    assign A_equal = ~|result; // A is equal to B if result is zero
    assign A_less = borrow_3; // A is less than B if borrow occurs
    
endmodule