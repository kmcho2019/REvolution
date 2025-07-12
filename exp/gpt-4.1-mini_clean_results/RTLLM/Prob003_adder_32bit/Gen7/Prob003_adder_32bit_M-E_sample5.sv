module cla_4bit (
    input  [4:1] A,
    input  [4:1] B,
    input        Cin,
    output [4:1] S,
    output       Pout,
    output       Gout,
    output       Cout
);
    wire [4:1] P;   // Propagate
    wire [4:1] G;   // Generate
    wire [4:0] C;   // Carry signals, C[0]=Cin

    assign C[0] = Cin;

    genvar i;
    generate
        for (i = 1; i <=4; i = i+1) begin : pg
            assign P[i] = A[i] ^ B[i];
            assign G[i] = A[i] & B[i];
        end
    endgenerate

    // Carry-lookahead logic for 4 bits:
    // C[1] = G[1] | (P[1] & C[0])
    // C[2] = G[2] | (P[2] & G[1]) | (P[2]&P[1]&C[0])
    // C[3] = G[3] | (P[3] & G[2]) | (P[3]&P[2]&G[1]) | (P[3]&P[2]&P[1]&C[0])
    // C[4] = G[4] | (P[4] & G[3]) | (P[4]&P[3]&G[2]) | (P[4]&P[3]&P[2]&G[1]) | (P[4]&P[3]&P[2]&P[1]&C[0])

    assign C[1] = G[1] | (P[1] & C[0]);
    assign C[2] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & C[0]);
    assign C[3] = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & C[0]);
    assign C[4] = G[4] | (P[4] & G[3]) | (P[4] & P[3] & G[2]) | (P[4] & P[3] & P[2] & G[1]) | (P[4] & P[3] & P[2] & P[1] & C[0]);

    generate
        for (i = 1; i <= 4; i = i + 1) begin : sum_bits
            assign S[i] = P[i] ^ C[i-1];
        end
    endgenerate

    // Group propagate is AND of all bit propagates
    assign Pout = &P[4:1]; // AND of P[4],P[3],P[2],P[1]
    // Group generate uses carry-lookahead generate of 4 bits (carry-out from block without Cin):
    // Gout = G[4] | (P[4]&G[3]) | (P[4]&P[3]&G[2]) | (P[4]&P[3]&P[2]&G[1])
    assign Gout = G[4] | (P[4] & G[3]) | (P[4] & P[3] & G[2]) | (P[4] & P[3] & P[2] & G[1]);

    assign Cout = C[4];
endmodule


module cla_16bit (
    input  [16:1] A,
    input  [16:1] B,
    input         Cin,
    output [16:1] S,
    output        Cout
);
    // Four 4-bit CLA sub-blocks
    wire [3:0] Psub; // Group propagate for each 4-bit block
    wire [3:0] Gsub; // Group generate for each 4-bit block
    wire [4:0] Csub; // Carry signals at block level: Csub[0]=Cin, Csub[4]=Cout

    assign Csub[0] = Cin;

    // Instantiate 4 4-bit CLA blocks
    cla_4bit cla0 (
        .A   (A[4:1]),
        .B   (B[4:1]),
        .Cin (Csub[0]),
        .S   (S[4:1]),
        .Pout(Psub[0]),
        .Gout(Gsub[0]),
        .Cout()
    );
    cla_4bit cla1 (
        .A   (A[8:5]),
        .B   (B[8:5]),
        .Cin (Csub[1]),
        .S   (S[8:5]),
        .Pout(Psub[1]),
        .Gout(Gsub[1]),
        .Cout()
    );
    cla_4bit cla2 (
        .A   (A[12:9]),
        .B   (B[12:9]),
        .Cin (Csub[2]),
        .S   (S[12:9]),
        .Pout(Psub[2]),
        .Gout(Gsub[2]),
        .Cout()
    );
    cla_4bit cla3 (
        .A   (A[16:13]),
        .B   (B[16:13]),
        .Cin (Csub[3]),
        .S   (S[16:13]),
        .Pout(Psub[3]),
        .Gout(Gsub[3]),
        .Cout()
    );

    // Compute carry-ins for each 4-bit sub-block using 4-bit CLA style carry-lookahead on group signals
    // Using same equations as in cla_4bit for carry computation on Psub and Gsub
    // Csub[1] = Gsub[0] | (Psub[0] & Csub[0])
    // Csub[2] = Gsub[1] | (Psub[1] & Gsub[0]) | (Psub[1] & Psub[0] & Csub[0])
    // Csub[3] = Gsub[2] | (Psub[2] & Gsub[1]) | (Psub[2] & Psub[1] & Gsub[0]) | (Psub[2] & Psub[1] & Psub[0] & Csub[0])
    // Csub[4] = Gsub[3] | (Psub[3] & Gsub[2]) | (Psub[3] & Psub[2] & Gsub[1]) | (Psub[3] & Psub[2] & Psub[1] & Gsub[0]) | (Psub[3] & Psub[2] & Psub[1] & Psub[0] & Csub[0])

    assign Csub[1] = Gsub[0] | (Psub[0] & Csub[0]);
    assign Csub[2] = Gsub[1] | (Psub[1] & Gsub[0]) | (Psub[1] & Psub[0] & Csub[0]);
    assign Csub[3] = Gsub[2] | (Psub[2] & Gsub[1]) | (Psub[2] & Psub[1] & Gsub[0]) | (Psub[2] & Psub[1] & Psub[0] & Csub[0]);
    assign Csub[4] = Gsub[3] | (Psub[3] & Gsub[2]) | (Psub[3] & Psub[2] & Gsub[1]) | (Psub[3] & Psub[2] & Psub[1] & Gsub[0]) | (Psub[3] & Psub[2] & Psub[1] & Psub[0] & Csub[0]);

    assign Cout = Csub[4];
endmodule


module adder_32bit (
    input  [32:1] A,
    input  [32:1] B,
    output [32:1] S,
    output        C32
);
    wire C16;

    cla_16bit cla_lower (
        .A   (A[16:1]),
        .B   (B[16:1]),
        .Cin (1'b0),
        .S   (S[16:1]),
        .Cout(C16)
    );

    cla_16bit cla_upper (
        .A   (A[32:17]),
        .B   (B[32:17]),
        .Cin (C16),
        .S   (S[32:17]),
        .Cout(C32)
    );
endmodule