// Module A: z = (x ^ y) & x implemented behaviorally
module A(input logic x, input logic y, output logic z);
    always_comb begin
        z = (x ^ y) & x;
    end
endmodule

// Module B: Implements the logic observed from the waveform, which matches XNOR behavior
module B(input logic x, input logic y, output logic z);
    always_comb begin
        z = ~(x ^ y);
    end
endmodule

// Intermediate combinational block implementing (a1 | b1) ^ (a2 & b2)
module CombBlock(input logic a1, b1, a2, b2, output logic z);
    always_comb begin
        z = (a1 | b1) ^ (a2 & b2);
    end
endmodule

// Top-level module with single A and B instances, outputs duplicated to feed the logic
module TopModule(input logic x, input logic y, output logic z);
    logic a_out, b_out;

    // Single instances of A and B
    A instA(.x(x), .y(y), .z(a_out));
    B instB(.x(x), .y(y), .z(b_out));

    // Use CombBlock to implement the OR and AND gate logic with duplicated inputs from single outputs
    CombBlock comb(
        .a1(a_out), .b1(b_out),
        .a2(a_out), .b2(b_out),
        .z(z)
    );
endmodule