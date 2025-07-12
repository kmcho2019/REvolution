module mux2to1 (
    input  wire sel,
    input  wire in0,
    input  wire in1,
    output wire out
);
    assign out = sel ? in1 : in0;
endmodule

module TopModule (
    input  wire c,
    input  wire d,
    output wire [3:0] mux_in
);
    // For ab=00 (mux_in[0]) = f0 = 1 when cd=01,11,10; 0 when cd=00
    // This is f0 = d OR c
    wire f0;
    // d ? 1 : c  implements c + d
    mux2to1 mux0 (.sel(d), .in0(c), .in1(1'b1), .out(f0));

    // For ab=01 (mux_in[1]) = f1 = always 0 (from K-map)
    wire f1 = 1'b0;

    // For ab=11 (mux_in[2]) = f2 = 1 only at cd=11; else 0
    // This is c AND d
    wire f2;
    // d ? c : 0 implements c & d
    mux2to1 mux2 (.sel(d), .in0(1'b0), .in1(c), .out(f2));

    // For ab=10 (mux_in[3]) = f3 = 1 at cd=00,11,10; 0 at cd=01
    // Expression: f3 = (~d) + c
    // ~d = d ? 0 : 1, so ~d can be mux with sel=d, in0=1, in1=0
    // f3 = c + ~d = c ? 1 : ~d
    wire f3;
    wire not_d;
    mux2to1 mux_notd (.sel(d), .in0(1'b1), .in1(1'b0), .out(not_d));
    mux2to1 mux3 (.sel(c), .in0(not_d), .in1(1'b1), .out(f3));

    assign mux_in = {f3, f2, f1, f0};
endmodule