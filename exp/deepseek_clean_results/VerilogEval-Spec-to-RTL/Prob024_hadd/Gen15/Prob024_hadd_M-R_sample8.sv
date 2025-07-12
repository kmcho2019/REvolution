module Mux2to1(
    input sel,
    input in0,
    input in1,
    output out
);
    assign out = sel ? in1 : in0;
endmodule

module TopModule(
    input a,
    input b,
    output sum,
    output cout
);
    wire not_a;
    assign not_a = ~a;
    
    // Sum output: b ? ~a : a
    Mux2to1 sum_mux(
        .sel(b),
        .in0(a),
        .in1(not_a),
        .out(sum)
    );
    
    // Carry output: b ? a : 0
    Mux2to1 cout_mux(
        .sel(b),
        .in0(1'b0),
        .in1(a),
        .out(cout)
    );
endmodule