module NORGate (
    input  in1,
    input  in2,
    output out
);
    // Use Verilog primitive nor gate for direct hardware mapping and minimal delay
    nor nor1(out, in1, in2);
endmodule

module TopModule (
    input  a,
    input  b,
    output out
);
    // Instantiate the primitive NORGate module
    NORGate u_nor (.in1(a), .in2(b), .out(out));
endmodule