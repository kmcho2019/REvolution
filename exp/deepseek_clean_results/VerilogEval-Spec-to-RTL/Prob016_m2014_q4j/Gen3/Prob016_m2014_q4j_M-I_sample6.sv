module TopModule(
    input [3:0] x,
    input [3:0] y,
    output [4:0] sum
);

    wire [3:0] G, P;
    wire [3:1] C;

    // Generate and Propagate signals
    assign G = x & y;
    assign P = x ^ y;

    // Carry calculations
    assign C[1] = G[0] | (P[0] & 1'b0);
    assign C[2] = G[1] | (P[1] & G[0]);
    assign C[3] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]);
    assign sum[4] = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]);

    // Sum calculations
    assign sum[0] = P[0];
    assign sum[1] = P[1] ^ C[1];
    assign sum[2] = P[2] ^ C[2];
    assign sum[3] = P[3] ^ C[3];

endmodule