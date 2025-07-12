module NORGate(
    input  in1,
    input  in2,
    output out
);
    assign out = ~(in1 | in2);
endmodule

module TopModule (
    input  a,
    input  b,
    output out
);
    // Instantiate the NOR gate module for clarity and reuse
    NORGate u_nor(.in1(a), .in2(b), .out(out));
endmodule