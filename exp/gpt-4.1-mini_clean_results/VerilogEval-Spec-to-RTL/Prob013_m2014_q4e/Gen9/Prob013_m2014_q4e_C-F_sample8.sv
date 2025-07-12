module NorGate (
    input  a,
    input  b,
    output y
);
    // Behavioral assign implementing 2-input NOR directly
    assign y = ~(a | b);
endmodule

module TopModule (
    input  in1,
    input  in2,
    output out
);
    // Instantiate the simple single-bit NorGate module
    NorGate u_nor (
        .a(in1),
        .b(in2),
        .y(out)
    );
endmodule