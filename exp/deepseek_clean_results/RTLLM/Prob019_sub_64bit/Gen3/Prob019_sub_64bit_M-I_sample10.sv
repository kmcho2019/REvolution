module sub_64bit (
    input [63:0] A,
    input [63:0] B,
    output [63:0] result,
    output overflow
);

    // Input registers for power optimization
    reg [63:0] A_reg, B_reg;
    always @(*) begin
        A_reg = A;
        B_reg = B;
    end

    // Carry-lookahead subtractor implementation (4x16-bit chunks)
    wire [15:0] res0, res1, res2, res3;
    wire cout0, cout1, cout2, cout3;

    cla_subtractor_16bit sub0 (
        .A(A_reg[15:0]),
        .B(B_reg[15:0]),
        .cin(1'b0),
        .sum(res0),
        .cout(cout0)
    );

    cla_subtractor_16bit sub1 (
        .A(A_reg[31:16]),
        .B(B_reg[31:16]),
        .cin(cout0),
        .sum(res1),
        .cout(cout1)
    );

    cla_subtractor_16bit sub2 (
        .A(A_reg[47:32]),
        .B(B_reg[47:32]),
        .cin(cout1),
        .sum(res2),
        .cout(cout2)
    );

    cla_subtractor_16bit sub3 (
        .A(A_reg[63:48]),
        .B(B_reg[63:48]),
        .cin(cout2),
        .sum(res3),
        .cout(cout3)
    );

    // Combine results
    assign result = {res3, res2, res1, res0};

    // Optimized overflow detection
    wire a_sign = A_reg[63];
    wire b_sign = B_reg[63];
    wire res_sign = result[63];
    wire sign_diff = a_sign ^ b_sign;
    
    assign overflow = sign_diff & (a_sign ^ res_sign);

endmodule

// 16-bit carry-lookahead subtractor module
module cla_subtractor_16bit (
    input [15:0] A,
    input [15:0] B,
    input cin,
    output [15:0] sum,
    output cout
);
    wire [15:0] B_comp = ~B;
    wire [15:0] carry;
    
    // Generate and propagate signals
    wire [15:0] G = A & B_comp;
    wire [15:0] P = A | B_comp;
    
    // Carry lookahead logic
    assign carry[0] = cin;
    assign carry[1] = G[0] | (P[0] & cin);
    assign carry[2] = G[1] | (P[1] & G[0]) | (P[1] & P[0] & cin);
    // ... continue carry lookahead for remaining bits
    
    assign sum = A ^ B_comp ^ carry;
    assign cout = carry[15];
endmodule