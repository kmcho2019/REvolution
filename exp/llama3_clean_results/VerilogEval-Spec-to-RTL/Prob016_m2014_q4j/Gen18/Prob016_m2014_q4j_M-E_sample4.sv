// Prefix Adder module
module PrefixAdder(x, y, sum);
    input [3:0] x;
    input [3:0] y;
    output [4:0] sum;

    // Calculate half-sums using half-adders
    wire hs0, hs1, hs2, hs3;
    wire hc0, hc1, hc2, hc3;
    assign hs0 = x[0] ^ y[0];
    assign hc0 = x[0] & y[0];

    assign hs1 = x[1] ^ y[1];
    assign hc1 = x[1] & y[1];

    assign hs2 = x[2] ^ y[2];
    assign hc2 = x[2] & y[2];

    assign hs3 = x[3] ^ y[3];
    assign hc3 = x[3] & y[3];

    // Calculate prefix sums using OR gates
    wire ps0, ps1, ps2, ps3;
    assign ps0 = hc0;
    assign ps1 = hc0 | (hc1 & ~ps0);
    assign ps2 = hc0 | (hc1 & ~ps0) | (hc2 & ~(ps0 | ps1));
    assign ps3 = hc0 | (hc1 & ~ps0) | (hc2 & ~(ps0 | ps1)) | (hc3 & ~(ps0 | ps1 | ps2));

    // Calculate final sum using half-sums and prefix sums
    assign sum[0] = hs0;
    assign sum[1] = hs1 ^ ps0;
    assign sum[2] = hs2 ^ ps1;
    assign sum[3] = hs3 ^ ps2;
    assign sum[4] = ps3;

endmodule