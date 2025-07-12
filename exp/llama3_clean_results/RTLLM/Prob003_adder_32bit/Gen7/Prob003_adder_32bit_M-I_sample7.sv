// Improved 16-bit Carry-Lookahead Adder
module cla_16bit(
    input [16:1] A,
    input [16:1] B,
    input Cin,
    output [16:1] S,
    output Cout
);
    wire [16:1] c;
    assign c[1] = Cin;
    for (genvar i = 1; i <= 16; i++) begin
        assign S[i] = A[i] ^ B[i] ^ c[i];
        if (i < 16) begin
            assign c[i+1] = (A[i] & B[i]) | (A[i] & c[i]) | (B[i] & c[i]);
        end
    end
    assign Cout = c[16];
endmodule

// 32-bit Carry-Lookahead Adder using improved 16-bit CLA blocks
module adder_32bit(
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);
    wire C16;
    cla_16bit cla1(
     .A(A[16:1]),
     .B(B[16:1]),
     .Cin(1'b0),
     .S(S[16:1]),
     .Cout(C16)
    );
    cla_16bit cla2(
     .A(A[32:17]),
     .B(B[32:17]),
     .Cin(C16),
     .S(S[32:17]),
     .Cout(C32)
    );
endmodule