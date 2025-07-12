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
    // f0 = c OR d
    wire f0;
    mux2 or_f0(.sel(c), .in0(d), .in1(1'b1), .out(f0));

    // f1 = 0
    wire f1 = 1'b0;

    // f2 = c AND d
    wire f2;
    mux2 and_f2(.sel(c), .in0(1'b0), .in1(d), .out(f2));

    // Compute not_c = ~c and not_d = ~d
    wire not_c, not_d;
    mux2 inv_c(.sel(c), .in0(1'b1), .in1(1'b0), .out(not_c));
    mux2 inv_d(.sel(d), .in0(1'b1), .in1(1'b0), .out(not_d));

    // tmp = not_c AND not_d
    wire tmp;
    mux2 and_tmp(.sel(not_c), .in0(1'b0), .in1(not_d), .out(tmp));

    // f3 = c OR tmp
    wire f3;
    mux2 or_f3(.sel(c), .in0(tmp), .in1(1'b1), .out(f3));

    assign mux_in = {f3, f2, f1, f0};

endmodule