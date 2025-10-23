module TopModule(
    input  wire x,
    input  wire y,
    output wire z
);
    wire sel;
    wire d0 = 1'b1;
    wire d1 = 1'b0;

    assign sel = x ^ y;         // Select line for mux: 1 if x != y, 0 if x == y
    assign z = (~sel & d0) | (sel & d1); // Multiplexer output
endmodule