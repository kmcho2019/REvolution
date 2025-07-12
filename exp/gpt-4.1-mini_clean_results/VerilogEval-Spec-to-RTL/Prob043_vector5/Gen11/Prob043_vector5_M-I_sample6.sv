module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);
    // Index map:
    // inputs: i=0:a,1:b,2:c,3:d,4:e
    // out bit at position 5*i + j corresponds to comparison of input[i] and input[j]

    wire [4:0] in_vec = {a,b,c,d,e};

    // Compute unique pairs (i <= j) only
    // Diagonal elements (i==j) are always 1 (x==x)
    // Unique pairs with i < j:
    // (0,1),(0,2),(0,3),(0,4)
    // (1,2),(1,3),(1,4)
    // (2,3),(2,4)
    // (3,4)

    wire ab = ~(a ^ b);
    wire ac = ~(a ^ c);
    wire ad = ~(a ^ d);
    wire ae = ~(a ^ e);

    wire bc = ~(b ^ c);
    wire bd = ~(b ^ d);
    wire be = ~(b ^ e);

    wire cd = ~(c ^ d);
    wire ce = ~(c ^ e);

    wire de = ~(d ^ e);

    // Build output vector (25 bits)
    // out[24:0] = {5 rows of 5 bits each}
    // Each bit is out[5*i + j] = equality(a_i,a_j)

    assign out = {
        1'b1,    ab,     ac,     ad,     ae,     // row 0: a==a,a==b,...
        ab,      1'b1,   bc,     bd,     be,     // row 1: b==a,b==b,...
        ac,      bc,     1'b1,   cd,     ce,     // row 2: c==a,c==b,...
        ad,      bd,     cd,     1'b1,   de,     // row 3: d==a,d==b,...
        ae,      be,     ce,     de,     1'b1    // row 4: e==a,e==b,...
    };

endmodule