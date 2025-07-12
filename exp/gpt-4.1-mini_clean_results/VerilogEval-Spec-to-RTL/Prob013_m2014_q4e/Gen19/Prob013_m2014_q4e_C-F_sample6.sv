module ParamGate #(
    parameter FUNCTION = 1 // 0 = OR, 1 = NOR
) (
    input  wire a,
    input  wire b,
    output wire y
);
    // FUNCTION: 0 = OR, 1 = NOR
    // Implemented with continuous assignment for minimal delay and area
    assign y = (FUNCTION == 0) ? (a | b) :
               (FUNCTION == 1) ? ~(a | b) :
               1'bx; // invalid FUNCTION value
endmodule

module TopModule (
    input  wire in1,
    input  wire in2,
    output wire out
);
    // Instantiate ParamGate with FUNCTION=1 for NOR gate
    ParamGate #(.FUNCTION(1)) u_nor (
        .a(in1),
        .b(in2),
        .y(out)
    );
endmodule