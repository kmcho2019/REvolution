// Module A: z = (x ^ y) & x
module A(input x, input y, output z);
    assign z = (x ^ y) & x;
endmodule

// Module B: output matches the waveform from the problem (inferred as ~(x ^ y))
module B(input x, input y, output z);
    assign z = ~(x ^ y);
endmodule

// Simplified Top-level module: instantiate one A and one B, output z = A_out ^ B_out
module TopModule(input x, input y, output z);
    wire a_out, b_out;

    A A_inst(.x(x), .y(y), .z(a_out));
    B B_inst(.x(x), .y(y), .z(b_out));
    
    assign z = a_out ^ b_out;
endmodule