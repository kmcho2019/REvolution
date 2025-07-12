// Module A: z = (x ^ y) & x
module A(input wire x, input wire y, output wire z);
    assign z = (x ^ y) & x;
endmodule

// Module B: inferred from waveform as XNOR function
module B(input wire x, input wire y, output wire z);
    assign z = ~(x ^ y);
endmodule

// Top-level module with two instances each of A and B,
// wiring outputs accordingly and connecting per specification
module TopModule(input wire x, input wire y, output wire z);
    // Outputs from first pair of A and B
    wire a_out_1, b_out_1;
    // Outputs from second pair of A and B
    wire a_out_2, b_out_2;

    // Instantiate first pair
    A a1(.x(x), .y(y), .z(a_out_1));
    B b1(.x(x), .y(y), .z(b_out_1));

    // Instantiate second pair
    A a2(.x(x), .y(y), .z(a_out_2));
    B b2(.x(x), .y(y), .z(b_out_2));

    // OR gate connecting first pair outputs
    wire or_out = a_out_1 | b_out_1;

    // AND gate connecting second pair outputs
    wire and_out = a_out_2 & b_out_2;

    // XOR the results to produce final output
    assign z = or_out ^ and_out;
endmodule