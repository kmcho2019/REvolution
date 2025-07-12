module adder_8bit_cla (
    input  [7:0] a,
    input  [7:0] b,
    input        Cin,
    output [7:0] y,
    output       Co
);
    wire [7:0] P; // propagate
    wire [7:0] G; // generate
    wire [7:1] C; // internal carries

    // Generate propagate and generate signals
    assign P = a ^ b;   // propagate: if either bit is 1
    assign G = a & b;   // generate: if both bits are 1

    // Carry lookahead logic
    assign C[1] = G[0] | (P[0] & Cin);
    assign C[2] = G[1] | (P[1] & G[0]) | (P[1] & P[0] & Cin);
    assign C[3] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]) | (P[2] & P[1] & P[0] & Cin);
    assign C[4] = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]) | (P[3] & P[2] & P[1] & P[0] & Cin);
    assign C[5] = G[4] | (P[4] & G[3]) | (P[4] & P[3] & G[2]) | (P[4] & P[3] & P[2] & G[1]) 
                 | (P[4] & P[3] & P[2] & P[1] & G[0]) | (P[4] & P[3] & P[2] & P[1] & P[0] & Cin);
    assign C[6] = G[5] | (P[5] & G[4]) | (P[5] & P[4] & G[3]) | (P[5] & P[4] & P[3] & G[2]) 
                 | (P[5] & P[4] & P[3] & P[2] & G[1]) | (P[5] & P[4] & P[3] & P[2] & P[1] & G[0]) 
                 | (P[5] & P[4] & P[3] & P[2] & P[1] & P[0] & Cin);
    assign C[7] = G[6] | (P[6] & G[5]) | (P[6] & P[5] & G[4]) | (P[6] & P[5] & P[4] & G[3]) 
                 | (P[6] & P[5] & P[4] & P[3] & G[2]) | (P[6] & P[5] & P[4] & P[3] & P[2] & G[1])
                 | (P[6] & P[5] & P[4] & P[3] & P[2] & P[1] & G[0]) 
                 | (P[6] & P[5] & P[4] & P[3] & P[2] & P[1] & P[0] & Cin);

    // Carry out of the adder (C8)
    assign Co = G[7] | (P[7] & C[7]);

    // Sum bits calculation
    assign y[0] = P[0] ^ Cin;
    assign y[1] = P[1] ^ C[1];
    assign y[2] = P[2] ^ C[2];
    assign y[3] = P[3] ^ C[3];
    assign y[4] = P[4] ^ C[4];
    assign y[5] = P[5] ^ C[5];
    assign y[6] = P[6] ^ C[6];
    assign y[7] = P[7] ^ C[7];

endmodule


module adder_16bit (
    input  [15:0] a,
    input  [15:0] b,
    input         Cin,
    output [15:0] y,
    output        Co
);
    wire carry_mid;

    // Lower 8 bits CLA
    adder_8bit_cla cla_lower (
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .y(y[7:0]),
        .Co(carry_mid)
    );

    // Upper 8 bits CLA
    adder_8bit_cla cla_upper (
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(carry_mid),
        .y(y[15:8]),
        .Co(Co)
    );
endmodule