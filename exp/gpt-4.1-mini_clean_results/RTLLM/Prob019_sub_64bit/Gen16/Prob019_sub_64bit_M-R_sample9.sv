module sub_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire        overflow
);
    wire [63:0] B_comp = ~B;       // bitwise inversion of B
    wire [63:0] sum;
    wire        cout;

    // Instantiate prefix_adder64 for A + (~B) + 1 (subtract B)
    prefix_adder64 prefix_adder_inst (
        .A   (A),
        .B   (B_comp),
        .cin (1'b1),
        .sum (sum),
        .cout(cout)
    );

    assign result = sum;

    // Overflow detection: 
    // overflow = (A[63] != B[63]) && (result[63] != A[63])
    wire A_sign      = A[63];
    wire B_sign      = B[63];
    wire result_sign = result[63];
    assign overflow = (A_sign != B_sign) && (result_sign != A_sign);

endmodule


// 64-bit Prefix Adder using Kogge-Stone style carry computation
module prefix_adder64 (
    input  wire [63:0] A,
    input  wire [63:0] B,
    input  wire        cin,
    output wire [63:0] sum,
    output wire        cout
);
    // Each bit has propagate and generate:
    // p[i] = A[i] ^ B[i]
    // g[i] = A[i] & B[i]

    wire [63:0] p = A ^ B;
    wire [63:0] g = A & B;

    // Stage wires for carry lookahead: 
    // At each stage combine (g,p) pairs for groups of bits with doubling span
    
    // Level 0: (original)
    wire [63:0] g0 = g;
    wire [63:0] p0 = p;

    // Level 1: combine pairs (distance 1)
    wire [63:0] g1;
    wire [63:0] p1;
    assign g1[0] = g0[0];
    assign p1[0] = p0[0];
    genvar i;
    generate
        for (i=1; i<64; i=i+1) begin
            assign g1[i] = g0[i] | (p0[i] & g0[i-1]);
            assign p1[i] = p0[i] & p0[i-1];
        end
    endgenerate

    // Level 2: distance 2
    wire [63:0] g2;
    wire [63:0] p2;
    assign g2[0] = g1[0];
    assign g2[1] = g1[1];
    assign p2[0] = p1[0];
    assign p2[1] = p1[1];
    generate
        for (i=2; i<64; i=i+1) begin
            assign g2[i] = g1[i] | (p1[i] & g1[i-2]);
            assign p2[i] = p1[i] & p1[i-2];
        end
    endgenerate

    // Level 3: distance 4
    wire [63:0] g3;
    wire [63:0] p3;
    assign g3[0] = g2[0];
    assign g3[1] = g2[1];
    assign g3[2] = g2[2];
    assign g3[3] = g2[3];
    assign p3[0] = p2[0];
    assign p3[1] = p2[1];
    assign p3[2] = p2[2];
    assign p3[3] = p2[3];
    generate
        for (i=4; i<64; i=i+1) begin
            assign g3[i] = g2[i] | (p2[i] & g2[i-4]);
            assign p3[i] = p2[i] & p2[i-4];
        end
    endgenerate

    // Level 4: distance 8
    wire [63:0] g4;
    wire [63:0] p4;
    for (i=0; i<8; i=i+1) begin
        assign g4[i] = g3[i];
        assign p4[i] = p3[i];
    end
    generate
        for (i=8; i<64; i=i+1) begin
            assign g4[i] = g3[i] | (p3[i] & g3[i-8]);
            assign p4[i] = p3[i] & p3[i-8];
        end
    endgenerate

    // Level 5: distance 16
    wire [63:0] g5;
    wire [63:0] p5;
    for (i=0; i<16; i=i+1) begin
        assign g5[i] = g4[i];
        assign p5[i] = p4[i];
    end
    generate
        for (i=16; i<64; i=i+1) begin
            assign g5[i] = g4[i] | (p4[i] & g4[i-16]);
            assign p5[i] = p4[i] & p4[i-16];
        end
    endgenerate

    // Level 6: distance 32
    wire [63:0] g6;
    wire [63:0] p6;
    for (i=0; i<32; i=i+1) begin
        assign g6[i] = g5[i];
        assign p6[i] = p5[i];
    end
    generate
        for (i=32; i<64; i=i+1) begin
            assign g6[i] = g5[i] | (p5[i] & g5[i-32]);
            assign p6[i] = p5[i] & p5[i-32];
        end
    endgenerate

    // Now compute carries:
    // C[0] = cin
    // C[i+1] = g6[i] | (p6[i] & C[0]) for i=0..63

    wire [64:0] C;
    assign C[0] = cin;
    generate
        for (i=0; i<64; i=i+1) begin
            assign C[i+1] = g6[i] | (p6[i] & C[0]);
        end
    endgenerate

    // sum[i] = p[i] ^ C[i]
    assign sum = p ^ C[63:0];
    assign cout = C[64];

endmodule