module mux2 (
    input  sel,
    input  in0,
    input  in1,
    output out
);
    assign out = sel ? in1 : in0;
endmodule

// Implement a 1-variable function f(d) with truth table (for d=0 and d=1)
module func1_d (
    input d,
    output out,
    input val0,  // output when d=0
    input val1   // output when d=1
);
    mux2 m(.sel(d), .in0(val0), .in1(val1), .out(out));
endmodule

// Implement a 2-variable function f(c,d) using mux2, with values val_cd for cd=00,01,11,10
// Order of val_cd: cd=00,val0; cd=01,val1; cd=11,val2; cd=10,val3
// Use c as top selector:
// f = c ? f(c=1,d) : f(c=0,d)
// where f(c=x,d) is func1_d with two vals (d=0,d=1) from val_cd accordingly
module func2_cd (
    input c,
    input d,
    output out,
    input val_cd_00,
    input val_cd_01,
    input val_cd_11,
    input val_cd_10
);
    wire low_c;  // f(c=0,d)
    wire high_c; // f(c=1,d)

    func1_d f0(.d(d), .out(low_c),  .val0(val_cd_00), .val1(val_cd_01)); // c=0: d=0 and d=1 values
    func1_d f1(.d(d), .out(high_c), .val0(val_cd_10), .val1(val_cd_11)); // c=1: d=0 and d=1 values (note cd=10,val_cd_10 and cd=11,val_cd_11)

    mux2 m(.sel(c), .in0(low_c), .in1(high_c), .out(out));
endmodule


module TopModule (
    input  c,
    input  d,
    output [3:0] mux_in
);

    // For each mux_in[i], define the function of c,d using K-map columns:
    // mux_in[0]: ab=00 column cd=00->0,01->1,11->1,10->1
    func2_cd f0 (.c(c), .d(d), .out(mux_in[0]),
        .val_cd_00(1'b0),
        .val_cd_01(1'b1),
        .val_cd_11(1'b1),
        .val_cd_10(1'b1));

    // mux_in[1]: ab=01, all zero
    func2_cd f1 (.c(c), .d(d), .out(mux_in[1]),
        .val_cd_00(1'b0),
        .val_cd_01(1'b0),
        .val_cd_11(1'b0),
        .val_cd_10(1'b0));

    // mux_in[2]: ab=11, cd=00->0,01->0,11->1,10->0
    func2_cd f2 (.c(c), .d(d), .out(mux_in[2]),
        .val_cd_00(1'b0),
        .val_cd_01(1'b0),
        .val_cd_11(1'b1),
        .val_cd_10(1'b0));

    // mux_in[3]: ab=10, cd=00->1,01->0,11->1,10->1
    func2_cd f3 (.c(c), .d(d), .out(mux_in[3]),
        .val_cd_00(1'b1),
        .val_cd_01(1'b0),
        .val_cd_11(1'b1),
        .val_cd_10(1'b1));

endmodule