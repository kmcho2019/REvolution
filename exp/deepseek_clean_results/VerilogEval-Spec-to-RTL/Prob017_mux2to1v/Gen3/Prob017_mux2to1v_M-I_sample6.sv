module TopModule #(
    parameter WIDTH = 100
) (
    input  [WIDTH-1:0] a,     // Input A (100-bit by default)
    input  [WIDTH-1:0] b,     // Input B (100-bit by default)
    input              sel,   // Selection signal (0: A, 1: B)
    input              en,    // Output enable (active high)
    output [WIDTH-1:0] out    // Output (tri-state when disabled)
);

    // Parameterized 2:1 multiplexer with output enable
    // When disabled (en=0), output remains high-impedance
    // When enabled (en=1), behaves as normal 2:1 mux
    assign out = en ? (sel ? b : a) : {WIDTH{1'bz}};

endmodule