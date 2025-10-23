module TopModule (
    input  wire a,
    input  wire b,
    output wire q
);
    // Implement q = a & b using a 2:1 mux with a as select
    // If a=0, q=0; if a=1, q=b
    mux2to1 u_mux (
        .sel(a),
        .in0(1'b0),
        .in1(b),
        .out(q)
    );
endmodule

// 2-to-1 Multiplexer module
module mux2to1 (
    input  wire sel,
    input  wire in0,
    input  wire in1,
    output wire out
);
    // Output = sel ? in1 : in0
    assign out = sel ? in1 : in0;
endmodule