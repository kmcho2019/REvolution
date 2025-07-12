module cla_4bit #(parameter WIDTH = 4) (
    input [WIDTH-1:0] A,
    input [WIDTH-1:0] B,
    input Cin,
    output [WIDTH-1:0] S,
    output Cout
);
    wire [WIDTH-1:0] G = A & B;
    wire [WIDTH-1:0] P = A ^ B;
    wire [WIDTH:0] C;
    
    assign C[0] = Cin;
    genvar i;
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin : carry_chain
            assign C[i+1] = G[i] | (P[i] & C[i]);
        end
    endgenerate
    
    assign Cout = C[WIDTH];
    assign S = P ^ C[WIDTH-1:0];
endmodule

module cla_16bit (
    input [15:0] A,
    input [15:0] B,
    input Cin,
    output [15:0] S,
    output Cout
);
    wire [3:0] carry;
    
    cla_4bit #(4) cla0 (.A(A[3:0]), .B(B[3:0]), .Cin(Cin), .S(S[3:0]), .Cout(carry[0]));
    cla_4bit #(4) cla1 (.A(A[7:4]), .B(B[7:4]), .Cin(carry[0]), .S(S[7:4]), .Cout(carry[1]));
    cla_4bit #(4) cla2 (.A(A[11:8]), .B(B[11:8]), .Cin(carry[1]), .S(S[11:8]), .Cout(carry[2]));
    cla_4bit #(4) cla3 (.A(A[15:12]), .B(B[15:12]), .Cin(carry[2]), .S(S[15:12]), .Cout(carry[3]));
    
    assign Cout = carry[3];
endmodule

module adder_32bit (
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);
    wire C16;
    
    cla_16bit low (
        .A(A[16:1]),
        .B(B[16:1]),
        .Cin(1'b0),
        .S(S[16:1]),
        .Cout(C16)
    );
    
    cla_16bit high (
        .A(A[32:17]),
        .B(B[32:17]),
        .Cin(C16),
        .S(S[32:17]),
        .Cout(C32)
    );
endmodule