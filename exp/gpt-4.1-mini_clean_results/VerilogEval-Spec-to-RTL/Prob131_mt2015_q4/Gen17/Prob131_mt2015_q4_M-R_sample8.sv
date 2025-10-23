// Module A: combinational logic expressed inside an always_comb block
module A(input wire x, input wire y, output reg z);
    always @* begin
        z = (x ^ y) & x;
    end
endmodule

// Module B: behavioral always_comb block implementing z = ~(x ^ y)
module B(input wire x, input wire y, output reg z);
    always @* begin
        z = ~(x ^ y);
    end
endmodule

// Top-level module instantiating two A and two B modules,
// combining outputs by continuous assignments for OR, AND, XOR
module TopModule(input wire x, input wire y, output wire z);
    wire a1_out, b1_out;
    wire a2_out, b2_out;
    wire or_out, and_out;

    // Instantiations of modules with behavioral combinational logic
    A A1(.x(x), .y(y), .z(a1_out));
    B B1(.x(x), .y(y), .z(b1_out));

    A A2(.x(x), .y(y), .z(a2_out));
    B B2(.x(x), .y(y), .z(b2_out));

    // Continuous assignments for gate-level operations
    assign or_out = a1_out | b1_out;
    assign and_out = a2_out & b2_out;
    assign z = or_out ^ and_out;
endmodule