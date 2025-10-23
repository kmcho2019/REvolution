// Define the TopModule with a novel architectural idea
module TopModule(
    input  [3:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // Internal wires for intermediate results
    wire and_result, or_result;

    // Combinational circuit for AND operation
    assign and_result = in[0] & in[1] & in[2] & in[3];

    // Combinational circuit for OR operation
    assign or_result = in[0] | in[1] | in[2] | in[3];

    // Combinational circuit for XOR operation using AND and OR results
    assign out_xor = (in[0] ^ in[1] ^ in[2] ^ in[3]);

    // Assign outputs
    assign out_and = and_result;
    assign out_or = or_result;

endmodule