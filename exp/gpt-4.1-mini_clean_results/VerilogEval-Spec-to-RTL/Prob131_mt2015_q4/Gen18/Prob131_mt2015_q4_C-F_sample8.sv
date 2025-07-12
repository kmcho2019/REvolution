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

// Top-level module instantiating one A and one B module,
// sharing their outputs to implement the required logic
module TopModule(input wire x, input wire y, output wire z);
    wire a_out, b_out;
    wire or_out, and_out;

    // Single instances of A and B modules to reduce redundancy
    A A1(.x(x), .y(y), .z(a_out));
    B B1(.x(x), .y(y), .z(b_out));

    // Structural logic gates combining shared outputs as per problem statement
    assign or_out = a_out | b_out;
    assign and_out = a_out & b_out;
    assign z = or_out ^ and_out;
endmodule