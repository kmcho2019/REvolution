// Module A: z = (x ^ y) & x, using continuous assign
module A(input wire x, input wire y, output wire z);
    assign z = (x ^ y) & x;
endmodule

// Module B: output determined by given waveform corresponds to z = ~(x ^ y)
module B(input wire x, input wire y, output wire z);
    assign z = ~(x ^ y);
endmodule

// Top-level module instantiating two A and two B modules as described
module TopModule(input wire x, input wire y, output wire z);
    wire a1_out, a2_out;
    wire b1_out, b2_out;
    wire or_out, and_out;

    A A1(.x(x), .y(y), .z(a1_out));
    B B1(.x(x), .y(y), .z(b1_out));
    assign or_out = a1_out | b1_out;

    A A2(.x(x), .y(y), .z(a2_out));
    B B2(.x(x), .y(y), .z(b2_out));
    assign and_out = a2_out & b2_out;

    assign z = or_out ^ and_out;
endmodule