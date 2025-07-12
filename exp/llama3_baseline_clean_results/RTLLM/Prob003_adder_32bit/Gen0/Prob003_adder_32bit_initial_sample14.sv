// 1-bit full adder
module full_adder(
    input A,
    input B,
    input Cin,
    output S,
    output Cout
);
    assign S = A ^ B ^ Cin;
    assign Cout = (A & B) | (A & Cin) | (B & Cin);
endmodule

// 4-bit carry-lookahead adder
module cla_4bit(
    input [4:1] A,
    input [4:1] B,
    input Cin,
    output [4:1] S,
    output Cout
);
    wire [3:0] G, P;
    wire [3:0] C;

    // Calculate generate (G) and propagate (P) signals
    assign G[0] = A[1] & B[1];
    assign P[0] = A[1] | B[1];
    assign G[1] = A[2] & B[2];
    assign P[1] = A[2] | B[2];
    assign G[2] = A[3] & B[3];
    assign P[2] = A[3] | B[3];
    assign G[3] = A[4] & B[4];
    assign P[3] = A[4] | B[4];

    // Calculate carry signals
    assign C[0] = Cin;
    assign C[1] = G[0] | (P[0] & C[0]);
    assign C[2] = G[1] | (P[1] & C[1]);
    assign C[3] = G[2] | (P[2] & C[2]);

    // Instantiate 1-bit full adders
    full_adder fa1(.A(A[1]), .B(B[1]), .Cin(C[0]), .S(S[1]), .Cout());
    full_adder fa2(.A(A[2]), .B(B[2]), .Cin(C[1]), .S(S[2]), .Cout());
    full_adder fa3(.A(A[3]), .B(B[3]), .Cin(C[2]), .S(S[3]), .Cout());
    full_adder fa4(.A(A[4]), .B(B[4]), .Cin(C[3]), .S(S[4]), .Cout());

    // Assign Cout
    assign Cout = G[3] | (P[3] & C[3]);
endmodule

// 16-bit carry-lookahead adder
module cla_16bit(
    input [16:1] A,
    input [16:1] B,
    input Cin,
    output [16:1] S,
    output Cout
);
    wire Cout1, Cout2, Cout3, Cout4;

    cla_4bit cla1(.A(A[4:1]), .B(B[4:1]), .Cin(Cin), .S(S[4:1]), .Cout(Cout1));
    cla_4bit cla2(.A(A[8:5]), .B(B[8:5]), .Cin(Cout1), .S(S[8:5]), .Cout(Cout2));
    cla_4bit cla3(.A(A[12:9]), .B(B[12:9]), .Cin(Cout2), .S(S[12:9]), .Cout(Cout3));
    cla_4bit cla4(.A(A[16:13]), .B(B[16:13]), .Cin(Cout3), .S(S[16:13]), .Cout(Cout4));

    assign Cout = Cout4;
endmodule

// 32-bit carry-lookahead adder
module adder_32bit(
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);
    wire Cout16;

    cla_16bit cla1(.A(A[16:1]), .B(B[16:1]), .Cin(1'b0), .S(S[16:1]), .Cout(Cout16));
    cla_16bit cla2(.A(A[32:17]), .B(B[32:17]), .Cin(Cout16), .S(S[32:17]), .Cout(C32));
endmodule