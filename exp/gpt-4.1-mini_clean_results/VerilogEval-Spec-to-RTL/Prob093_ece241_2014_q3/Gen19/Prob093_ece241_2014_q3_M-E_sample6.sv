module mux2 (
    input  sel,
    input  in0,
    input  in1,
    output out
);
    assign out = sel ? in1 : in0;
endmodule

module TopModule (
    input  c,
    input  d,
    output [3:0] mux_in
);
    // Inverters of c and d using mux2
    wire not_c, not_d;
    mux2 inv_c (.sel(c),  .in0(1'b1), .in1(1'b0), .out(not_c));
    mux2 inv_d (.sel(d),  .in0(1'b1), .in1(1'b0), .out(not_d));

    // Helper mux to implement AND and OR by mux2:
    // AND(x,y) = mux2(sel=x, in0=0, in1=y)
    // OR(x,y)  = mux2(sel=x, in0=1, in1=y)

    // ------------------------
    // mux_in[0]: ab=00
    // cd: 00=0,01=0,11=0,10=1
    // Let's write function as f0(c,d)
    // Treat d as selector:
    // d=0 => c=0->0, c=1->1
    // d=1 => always 0
    // so f0 = mux2(sel=d, in0=c, in1=0)
    wire f0;
    mux2 f0_mux (.sel(d), .in0(c), .in1(1'b0), .out(f0));

    // ------------------------
    // mux_in[1]: ab=01
    // cd: 00=1,01=0,11=0,10=0
    // Function f1(c,d)
    // d=0 => c=0->1, c=1->0
    // d=1 => always 0
    // So for d=0, f1 = NOT c; for d=1 f1=0
    // NOT c already known as not_c
    // f1 = mux2(sel=d, in0=not_c, in1=0)
    wire f1;
    mux2 f1_mux (.sel(d), .in0(not_c), .in1(1'b0), .out(f1));

    // ------------------------
    // mux_in[2]: ab=11
    // cd: 00=1,01=0,11=1,10=1
    // Let's look at d=0 and d=1 cases:
    // d=0: c=0->1, c=1->1 (both 1)
    // d=1: c=0->0, c=1->1
    // So when d=0, output=1 (constant)
    // when d=1, output = c
    // f2 = mux2(sel=d, in0=1, in1=c)
    wire f2;
    mux2 f2_mux (.sel(d), .in0(1'b1), .in1(c), .out(f2));

    // ------------------------
    // mux_in[3]: ab=10
    // cd: 00=1,01=0,11=0,10=1
    // Analyze by d selector:
    // d=0: c=0->1, c=1->1 (always 1)
    // d=1: c=0->0, c=1->0 (always 0)
    // f3 = mux2(sel=d, in0=1, in1=0)
    wire f3;
    mux2 f3_mux (.sel(d), .in0(1'b1), .in1(1'b0), .out(f3));

    assign mux_in = {f3, f2, f1, f0};
endmodule