module TopModule (
    input a,
    input b,
    input c,
    input d,
    input e,
    output [24:0] out
);

    // Compute all unique pairwise comparisons
    wire ab = a ~^ b;
    wire ac = a ~^ c;
    wire ad = a ~^ d;
    wire ae = a ~^ e;
    wire bc = b ~^ c;
    wire bd = b ~^ d;
    wire be = b ~^ e;
    wire cd = c ~^ d;
    wire ce = c ~^ e;
    wire de = d ~^ e;

    assign out = {
        1'b1,    ab,    ac,    ad,    ae,
        ab,      1'b1,  bc,    bd,    be,
        ac,      bc,    1'b1,  cd,    ce,
        ad,      bd,    cd,    1'b1,  de,
        ae,      be,    ce,    de,    1'b1
    };

endmodule