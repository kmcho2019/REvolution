module sub_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire        overflow
);
    // Complement B once for full 64-bit width
    wire [63:0] B_comp = ~B;

    // Lower and upper 32-bit segments of A and B_comp
    wire [31:0] A_lower = A[31:0];
    wire [31:0] A_upper = A[63:32];
    wire [31:0] B_comp_lower = B_comp[31:0];
    wire [31:0] B_comp_upper = B_comp[63:32];

    // Wires for lower and upper results and carry outs
    wire [31:0] res_lower;
    wire [31:0] res_upper;
    wire        carry_lower;
    wire        carry_upper;

    // Perform lower 32-bit addition: A_lower + (~B_lower) + 1 (carry-in = 1)
    cla_32bit cla_lower (
        .A   (A_lower),
        .B   (B_comp_lower),
        .cin (1'b1),
        .sum (res_lower),
        .cout(carry_lower)
    );

    // Perform upper 32-bit addition: A_upper + (~B_upper) + carry from lower
    cla_32bit cla_upper (
        .A   (A_upper),
        .B   (B_comp_upper),
        .cin (carry_lower),
        .sum (res_upper),
        .cout(carry_upper)
    );

    // Concatenate results for full 64-bit result
    assign result = {res_upper, res_lower};

    // Overflow detection:
    // Overflow if sign(A) != sign(B) and sign(result) != sign(A)
    wire A_sign      = A[63];
    wire B_sign      = B[63];
    wire result_sign = result[63];
    assign overflow = (A_sign != B_sign) && (result_sign != A_sign);

endmodule


// 32-bit Carry Lookahead Adder (CLA) with generate/propagate carry lookahead
module cla_32bit (
    input  wire [31:0] A,
    input  wire [31:0] B,
    input  wire        cin,
    output wire [31:0] sum,
    output wire        cout
);
    wire [31:0] P = A ^ B;    // Propagate
    wire [31:0] G = A & B;    // Generate
    wire [32:0] C;            // Carry signals

    assign C[0] = cin;

    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin : carry_gen
            assign C[i+1] = G[i] | (P[i] & C[i]);
        end
    endgenerate

    assign sum  = P ^ C[31:0];
    assign cout = C[32];
endmodule