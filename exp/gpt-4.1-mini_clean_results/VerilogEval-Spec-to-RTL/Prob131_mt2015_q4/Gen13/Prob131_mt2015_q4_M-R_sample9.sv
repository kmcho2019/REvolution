// Module A: z = (x ^ y) & x, using always_comb procedural block
module A(input logic x, input logic y, output logic z);
    always @(*) begin
        z = (x ^ y) & x;
    end
endmodule

// Module B: z = ~(x ^ y), using always_comb procedural block
module B(input logic x, input logic y, output logic z);
    always @(*) begin
        z = ~(x ^ y);
    end
endmodule

// Top-level module with two A and two B instances wired explicitly as described
module TopModule(input logic x, input logic y, output logic z);
    logic a1_out, a2_out;
    logic b1_out, b2_out;
    logic or_out, and_out;

    // First pair (A1 and B1)
    A A1(.x(x), .y(y), .z(a1_out));
    B B1(.x(x), .y(y), .z(b1_out));
    assign or_out = a1_out | b1_out;

    // Second pair (A2 and B2)
    A A2(.x(x), .y(y), .z(a2_out));
    B B2(.x(x), .y(y), .z(b2_out));
    assign and_out = a2_out & b2_out;

    // Final XOR to produce output
    assign z = or_out ^ and_out;
endmodule