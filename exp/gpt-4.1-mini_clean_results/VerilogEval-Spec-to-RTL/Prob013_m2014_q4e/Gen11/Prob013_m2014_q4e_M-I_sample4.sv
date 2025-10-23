module TopModule (
    input  in1,
    input  in2,
    output out
);
    // Direct continuous assign implementing 2-input NOR gate for minimal hierarchy and logic levels
    assign out = ~(in1 | in2);
endmodule