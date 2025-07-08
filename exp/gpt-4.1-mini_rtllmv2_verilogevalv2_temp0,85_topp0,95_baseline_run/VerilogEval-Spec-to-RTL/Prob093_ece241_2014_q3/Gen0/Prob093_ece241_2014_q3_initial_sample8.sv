module mux2to1 (
    input sel,
    input in0,
    input in1,
    output out
);
    assign out = sel ? in1 : in0;
endmodule

module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);
    wire c_and_d;
    wire c_or_d;

    // c_and_d = c & d using mux2to1: c as sel, inputs {0,d}
    mux2to1 and_mux (.sel(c), .in0(1'b0), .in1(d), .out(c_and_d));

    // c_or_d = c | d using mux2to1: c as sel, inputs {d,1}
    mux2to1 or_mux (.sel(c), .in0(d), .in1(1'b1), .out(c_or_d));

    assign mux_in[0] = c_or_d;      // ab=00 input to 4-to-1 mux
    assign mux_in[1] = 1'b0;        // ab=01 input to 4-to-1 mux
    assign mux_in[2] = c_and_d;     // ab=11 input to 4-to-1 mux
    assign mux_in[3] = c_or_d;      // ab=10 input to 4-to-1 mux
endmodule