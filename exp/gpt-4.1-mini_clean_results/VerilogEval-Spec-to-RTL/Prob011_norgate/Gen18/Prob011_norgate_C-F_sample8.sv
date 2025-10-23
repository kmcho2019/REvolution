module NORGate(
    input  in1,
    input  in2,
    output out
);
    // Directly implement the NOR function for optimal area and power
    assign out = ~(in1 | in2);
endmodule

module TopModule (
    input  a,
    input  b,
    output out
);
    // Instantiate the NOR gate module for modularity and clarity
    NORGate u_nor(.in1(a), .in2(b), .out(out));
endmodule