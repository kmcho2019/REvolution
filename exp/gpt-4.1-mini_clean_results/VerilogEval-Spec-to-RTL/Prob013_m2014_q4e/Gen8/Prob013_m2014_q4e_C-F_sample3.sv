module NorGate #(
    parameter WIDTH = 1
) (
    input  [WIDTH-1:0] a,
    input  [WIDTH-1:0] b,
    output [WIDTH-1:0] y
);
    // Behavioral assign implementing NOR directly for optimal PPA
    assign y = ~(a | b);
endmodule

module TopModule (
    input  in1,
    input  in2,
    output out
);
    // Instantiate parameterized 2-input NOR gate with 1-bit width
    NorGate #(.WIDTH(1)) u_nor (
        .a(in1),
        .b(in2),
        .y(out)
    );
endmodule