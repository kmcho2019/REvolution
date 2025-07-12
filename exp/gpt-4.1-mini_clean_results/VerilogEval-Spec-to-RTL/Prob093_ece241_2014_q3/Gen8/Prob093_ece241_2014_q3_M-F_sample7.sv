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
    // f0 = c + d = d ? 1 : c
    wire f0;
    mux2to1 mux_f0 (.sel(d), .in0(c), .in1(1'b1), .out(f0));

    // f1 = 0
    wire f1 = 1'b0;

    // f2 = c & d = d ? c : 0
    wire f2;
    mux2to1 mux_f2 (.sel(d), .in0(1'b0), .in1(c), .out(f2));

    // ~d = d ? 0 : 1
    wire not_d;
    mux2to1 mux_not_d (.sel(d), .in0(1'b1), .in1(1'b0), .out(not_d));

    // f3 = c + ~d = c ? 1 : ~d
    wire f3;
    mux2to1 mux_f3 (.sel(c), .in0(not_d), .in1(1'b1), .out(f3));

    assign mux_in = {f3, f2, f1, f0};
endmodule