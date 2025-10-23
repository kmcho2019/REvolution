module TopModule (
    input  wire a,
    input  wire b,
    output wire out
);
    wire not_a;
    wire not_b;
    wire nor_ab;

    // Instantiate NOT gates
    assign not_a = ~a;
    assign not_b = ~b;

    // NOR gate to complete De Morgan equivalent of AND
    assign nor_ab = ~(not_a | not_b);

    // Output is the result of the NOR gate
    assign out = nor_ab;
endmodule