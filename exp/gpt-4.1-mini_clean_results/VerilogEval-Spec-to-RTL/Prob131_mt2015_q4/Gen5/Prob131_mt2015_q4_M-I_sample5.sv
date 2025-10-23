// Module A: z = (x ^ y) & x
module A(input wire x, input wire y, output wire z);
    assign z = (x ^ y) & x;
endmodule

// Module B: output matches simulation waveform, i.e., XNOR function
module B(input wire x, input wire y, output wire z);
    assign z = ~(x ^ y);
endmodule

// Optimized top-level module:
// Instantiate one A and one B; output z = a_out XOR b_out directly,
// which simplifies the original ( (a_out | b_out) ^ (a_out & b_out) )
module TopModule(input wire x, input wire y, output wire z);
    wire a_out, b_out;

    A a_inst(.x(x), .y(y), .z(a_out));
    B b_inst(.x(x), .y(y), .z(b_out));

    // Simplified final output: (a_out | b_out) ^ (a_out & b_out) == a_out ^ b_out
    assign z = a_out ^ b_out;
endmodule