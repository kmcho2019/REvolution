module TopModule (
    input [1:0] A,
    input [1:0] B,
    output z
);
    wire [1:0] xnor_out;
    
    // Bitwise XNOR comparison
    assign xnor_out[0] = ~(A[0] ^ B[0]);
    assign xnor_out[1] = ~(A[1] ^ B[1]);
    
    // Final AND of all comparison bits
    assign z = xnor_out[0] & xnor_out[1];
endmodule