module TopModule (
    input [1:0] A,
    input [1:0] B,
    output z
);

    wire [1:0] xor_result;
    
    assign xor_result = A ^ B;  // Bitwise XOR
    assign z = ~|xor_result;    // NOR reduction of XOR results

endmodule