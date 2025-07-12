module TopModule (
    input a,
    input b,
    input c,
    input d,
    input e,
    output [24:0] out
);

    // Shared intermediate results for all unique comparisons
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

    // Assign outputs with shared comparisons and hardwired 1's for self-comparisons
    assign out[24:20] = {1'b1, ab, ac, ad, ae};
    assign out[19:15] = {ab, 1'b1, bc, bd, be};
    assign out[14:10] = {ac, bc, 1'b1, cd, ce};
    assign out[9:5]   = {ad, bd, cd, 1'b1, de};
    assign out[4:0]   = {ae, be, ce, de, 1'b1};

endmodule