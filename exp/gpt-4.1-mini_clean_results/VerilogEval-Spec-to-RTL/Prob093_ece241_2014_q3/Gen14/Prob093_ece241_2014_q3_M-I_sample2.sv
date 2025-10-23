// 2-to-1 multiplexer module
module mux2 (
    input  sel,
    input  in0,
    input  in1,
    output out
);
    assign out = sel ? in1 : in0;
endmodule

// NOT gate implemented using mux2: NOT x = mux2(sel=x, in0=1, in1=0)
module not_gate (
    input  in,
    output out
);
    mux2 inv(.sel(in), .in0(1'b1), .in1(1'b0), .out(out));
endmodule

// TopModule as per problem statement:
// Inputs: c,d
// Outputs: mux_in[3:0] = inputs to the 4-to-1 mux with selector inputs a,b outside this module.
// mux_in[0] = function for ab=00
// mux_in[1] = function for ab=01
// mux_in[2] = function for ab=11
// mux_in[3] = function for ab=10
module TopModule (
    input  c,
    input  d,
    output [3:0] mux_in
);

    // Implement NOT d for f3
    wire not_d;
    not_gate inv_d(.in(d), .out(not_d));

    // f0 = mux2(sel=c, in0=d, in1=1)
    wire f0;
    mux2 f0_mux(.sel(c), .in0(d), .in1(1'b1), .out(f0));

    // f1 = 0
    wire f1 = 1'b0;

    // f2 = mux2(sel=c, in0=0, in1=d)
    wire f2;
    mux2 f2_mux(.sel(c), .in0(1'b0), .in1(d), .out(f2));

    // f3 = mux2(sel=c, in0=not_d, in1=1)
    wire f3;
    mux2 f3_mux(.sel(c), .in0(not_d), .in1(1'b1), .out(f3));

    assign mux_in = {f3, f2, f1, f0};

endmodule