// 4-bit Carry-Lookahead Adder (CLA) module
module cla_4bit(
    input [4:1] A,  // 4-bit operand A
    input [4:1] B,  // 4-bit operand B
    input Cin,      // Carry-in
    output [4:1] S, // 4-bit sum
    output Cout     // Carry-out
);
    
    // Internal signals for generate (G) and propagate (P)
    wire [4:1] G, P;
    
    // Generate (G) and propagate (P) signals
    assign G[4:1] = A[4:1] & B[4:1];
    assign P[4:1] = A[4:1] | B[4:1];
    
    // Carry-lookahead logic for 4 bits
    wire C1, C2, C3, C4;
    assign C1 = Cin;
    assign C2 = G[2] | (P[2] & C1);
    assign C3 = G[3] | (P[3] & C2);
    assign C4 = G[4] | (P[4] & C3);
    
    // Sum calculation
    assign S[1] = A[1] ^ B[1] ^ Cin;
    assign S[2] = A[2] ^ B[2] ^ C2;
    assign S[3] = A[3] ^ B[3] ^ C3;
    assign S[4] = A[4] ^ B[4] ^ C4;
    
    // Carry-out
    assign Cout = G[4] | (P[4] & C3);
endmodule

// 16-bit Carry-Lookahead Adder (CLA) module
module cla_16bit(
    input [16:1] A,  // 16-bit operand A
    input [16:1] B,  // 16-bit operand B
    input Cin,      // Carry-in
    output [16:1] S, // 16-bit sum
    output Cout     // Carry-out
);
    
    // Instantiate four 4-bit CLA blocks
    wire C4_1, C4_2, C4_3;
    cla_4bit u1(
       .A(A[4:1]), 
       .B(B[4:1]), 
       .Cin(Cin), 
       .S(S[4:1]), 
       .Cout(C4_1)
    );
    
    cla_4bit u2(
       .A(A[8:5]), 
       .B(B[8:5]), 
       .Cin(C4_1), 
       .S(S[8:5]), 
       .Cout(C4_2)
    );
    
    cla_4bit u3(
       .A(A[12:9]), 
       .B(B[12:9]), 
       .Cin(C4_2), 
       .S(S[12:9]), 
       .Cout(C4_3)
    );
    
    cla_4bit u4(
       .A(A[16:13]), 
       .B(B[16:13]), 
       .Cin(C4_3), 
       .S(S[16:13]), 
       .Cout(Cout)
    );
endmodule

// 32-bit Carry-Lookahead Adder (CLA) module
module adder_32bit(
    input [32:1] A,  // 32-bit operand A
    input [32:1] B,  // 32-bit operand B
    output [32:1] S, // 32-bit sum
    output C32      // Carry-out
);
    
    // Instantiate two 16-bit CLA blocks
    wire C16;
    cla_16bit u1(
       .A(A[16:1]), 
       .B(B[16:1]), 
       .Cin(1'b0), 
       .S(S[16:1]), 
       .Cout(C16)
    );
    
    cla_16bit u2(
       .A(A[32:17]), 
       .B(B[32:17]), 
       .Cin(C16), 
       .S(S[32:17]), 
       .Cout(C32)
    );
endmodule