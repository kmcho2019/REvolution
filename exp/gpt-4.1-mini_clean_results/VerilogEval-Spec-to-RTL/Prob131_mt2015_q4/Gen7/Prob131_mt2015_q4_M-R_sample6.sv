// Module A: z = (x ^ y) & x
module A(input wire x, input wire y, output wire z);
    assign z = (x ^ y) & x;
endmodule

// Module B: inferred from waveform as XNOR function
module B(input wire x, input wire y, output wire z);
    assign z = ~(x ^ y);
endmodule

// Refactored top-level module:
// Use one instance each of A and B,
// implement combinational logic in an always_comb block
// for OR, AND, and XOR operations, driving the output 'z'.
module TopModule(input wire x, input wire y, output reg z);
    wire a_out, b_out;
    reg or_out, and_out;

    A a_inst(.x(x), .y(y), .z(a_out));
    B b_inst(.x(x), .y(y), .z(b_out));

    always @(*) begin
        or_out = a_out | b_out;
        and_out = a_out & b_out;
        z = or_out ^ and_out;
    end
endmodule