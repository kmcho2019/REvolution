// Three-input NOR gate module
module Nor3(
    input  a,
    input  b,
    input  c,
    output y
);
    assign y = ~(a | b | c);
endmodule

module TopModule (
    input  clk,
    input  x,
    output z
);

    // Flip-flop outputs (state)
    reg q_xor;
    reg q_and;
    reg q_or;

    // Initialize flip-flops to zero at simulation start
    initial begin
        q_xor = 1'b0;
        q_and = 1'b0;
        q_or  = 1'b0;
    end

    // Wires for each D input computed combinationally
    wire d_xor;
    wire d_and;
    wire d_or;

    // Compute D inputs as per problem
    assign d_xor = x ^ q_xor;      // XOR gate: x XOR Q output
    assign d_and = x & (~q_and);   // AND gate: x AND complemented Q output
    assign d_or  = x | (~q_or);    // OR gate: x OR complemented Q output

    // Sequential logic: positive-edge triggered flip-flops
    always @(posedge clk) begin
        q_xor <= d_xor;
        q_and <= d_and;
        q_or  <= d_or;
    end

    // Output z is NOR of the three flip-flop outputs using Nor3 module
    Nor3 nor_inst (
        .a(q_xor),
        .b(q_and),
        .c(q_or),
        .y(z)
    );

endmodule