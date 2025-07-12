module TopModule (
    input in1,
    input in2,
    input in3,
    output out
);
    // Combine inputs into a 3-bit vector
    wire [2:0] input_combination = {in1, in2, in3};
    
    // Define the truth table for the function: XNOR(in1,in2) XOR in3
    parameter [7:0] LUT = {
        1'b1, // 000: ~(0^0)^0 = 1^0 = 1
        1'b0, // 001: ~(0^0)^1 = 1^1 = 0
        1'b0, // 010: ~(0^1)^0 = 0^0 = 0
        1'b1, // 011: ~(0^1)^1 = 0^1 = 1
        1'b0, // 100: ~(1^0)^0 = 0^0 = 0
        1'b1, // 101: ~(1^0)^1 = 0^1 = 1
        1'b1, // 110: ~(1^1)^0 = 1^0 = 1
        1'b0  // 111: ~(1^1)^1 = 1^1 = 0
    };
    
    // Output the corresponding LUT value
    assign out = LUT[input_combination];
endmodule