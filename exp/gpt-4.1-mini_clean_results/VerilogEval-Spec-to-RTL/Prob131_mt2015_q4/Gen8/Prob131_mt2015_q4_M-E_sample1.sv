// Module A: z = (x ^ y) & x
module A(input wire x, input wire y, output wire z);
    assign z = (x ^ y) & x;
endmodule

// Module B: output waveform corresponds to XNOR function
module B(input wire x, input wire y, output wire z);
    assign z = ~(x ^ y);
endmodule

// CombinedA module: instantiates two A submodules internally, producing two outputs
module CombinedA(input wire x, input wire y, output wire z1, output wire z2);
    A a_inst1(.x(x), .y(y), .z(z1));
    A a_inst2(.x(x), .y(y), .z(z2));
endmodule

// CombinedB module: instantiates two B submodules internally, producing two outputs
module CombinedB(input wire x, input wire y, output wire z1, output wire z2);
    B b_inst1(.x(x), .y(y), .z(z1));
    B b_inst2(.x(x), .y(y), .z(z2));
endmodule

// Top-level module: instantiates CombinedA and CombinedB
// Uses outputs as per specification to compute final z
module TopModule(input wire x, input wire y, output wire z);
    wire a1, a2; // outputs from two A submodules within CombinedA
    wire b1, b2; // outputs from two B submodules within CombinedB
    wire or_out, and_out;

    // Instantiate combined modules
    CombinedA combined_a(.x(x), .y(y), .z1(a1), .z2(a2));
    CombinedB combined_b(.x(x), .y(y), .z1(b1), .z2(b2));

    // OR of first pair outputs (a1 | b1)
    assign or_out = a1 | b1;

    // AND of second pair outputs (a2 & b2)
    assign and_out = a2 & b2;

    // Final XOR output
    assign z = or_out ^ and_out;
endmodule