module Inverter (
    input  wire in,
    output wire out
);
    // Continuous assignment ensures minimal area, power, and delay
    assign out = ~in;
endmodule

module TopModule (
    input  wire in,
    output wire out
);
    // Using a generate block to keep design scalable and modular, 
    // though here it only instantiates a single inverter
    generate
        Inverter u_inv (
            .in(in),
            .out(out)
        );
    endgenerate
endmodule