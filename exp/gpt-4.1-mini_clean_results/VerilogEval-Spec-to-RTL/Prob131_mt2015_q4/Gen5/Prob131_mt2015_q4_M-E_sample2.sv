module A(input wire x, input wire y, output wire z);
    // Implements z = (x ^ y) & x
    assign z = (x ^ y) & x;
endmodule

module B(input wire x, input wire y, output wire z);
    // Implements B according to waveform: XNOR = ~(x ^ y)
    assign z = ~(x ^ y);
endmodule

module AB_Combo(input wire x, input wire y, output wire [1:0] z_out);
    // Bit 0: output of A, Bit 1: output of B
    wire a_z, b_z;

    A instA(.x(x), .y(y), .z(a_z));
    B instB(.x(x), .y(y), .z(b_z));

    assign z_out = {b_z, a_z};  // MSB is B output, LSB is A output
endmodule

module TopModule(input wire x, input wire y, output wire z);
    wire [1:0] combo1_out, combo2_out;
    wire [1:0] or_out, and_out;
    wire [1:0] xor_out;

    // Instantiate two AB combo modules
    AB_Combo combo1(.x(x), .y(y), .z_out(combo1_out));
    AB_Combo combo2(.x(x), .y(y), .z_out(combo2_out));

    // Bitwise OR and AND on outputs of combo1 and combo2
    assign or_out = combo1_out | combo2_out;
    assign and_out = combo1_out & combo2_out;

    // Bitwise XOR of OR and AND results
    assign xor_out = or_out ^ and_out;

    // Reduce xor_out bits with OR reduction to get final scalar output z
    assign z = |xor_out;
endmodule