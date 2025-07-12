module TopModule (
    input [1:0] A,
    input [1:0] B,
    output z
);
    wire [1:0] xor_out;
    
    assign xor_out = A ^ B;
    assign z = ~|xor_out;
endmodule