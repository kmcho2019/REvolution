module TopModule(
    input [3:0] x,
    input [3:0] y,
    output [4:0] sum
);

    wire [3:0] G, P;
    wire [4:0] C;

    // Generate and Propagate signals
    assign G = x & y;  // Generate
    assign P = x ^ y;  // Propagate

    // Carry lookahead logic
    assign C[0] = 1'b0;
    assign C[1] = G[0] | (P[0] & C[0]);
    assign C[2] = G[1] | (P[1] & G[0]) | (P[1] & P[0] & C[0]);
    assign C[3] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]) | (P[2] & P[1] & P[0] & C[0]);
    assign C[4] = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]) | (P[3] & P[2] & P[1] & P[0] & C[0]);

    // Sum calculation
    assign sum[0] = P[0] ^ C[0];
    assign sum[1] = P[1] ^ C[1];
    assign sum[2] = P[2] ^ C[2];
    assign sum[3] = P[3] ^ C[3];
    assign sum[4] = C[4];

endmodule