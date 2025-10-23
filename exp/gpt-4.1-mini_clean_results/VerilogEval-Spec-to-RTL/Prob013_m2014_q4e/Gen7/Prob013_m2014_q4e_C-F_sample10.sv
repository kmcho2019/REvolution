module NorGate (
    input wire a,
    input wire b,
    output wire y
);
    assign y = ~(a | b);
endmodule

module TopModule (
    input wire in1,
    input wire in2,
    output wire out
);
    NorGate nor_inst (
        .a(in1),
        .b(in2),
        .y(out)
    );
endmodule