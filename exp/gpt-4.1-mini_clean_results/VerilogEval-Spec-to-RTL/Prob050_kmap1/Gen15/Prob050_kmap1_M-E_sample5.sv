// Inverter module
module Inv (
    input  in,
    output out
);
    assign out = ~in;
endmodule

// 3-input AND gate module
module And3 (
    input  x,
    input  y,
    input  z,
    output q
);
    assign q = x & y & z;
endmodule

module TopModule (
    input  a,
    input  b,
    input  c,
    output out
);

    wire na, nb, nc; // inverted inputs
    wire and_out;    // output of AND gate
    wire nand_out;   // output after final inversion

    // Instantiate inverters for each input
    Inv inv_a (.in(a), .out(na));
    Inv inv_b (.in(b), .out(nb));
    Inv inv_c (.in(c), .out(nc));

    // AND gate for inverted inputs
    And3 and3_inst (
        .x(na),
        .y(nb),
        .z(nc),
        .q(and_out)
    );

    // Final inverter
    Inv inv_out (.in(and_out), .out(out));

endmodule