// Define the ParametricGate module
module ParametricGate(
    input  [3:0] in,
    input  [1:0] op,
    output out
);

    // Internal wires
    wire and_out, or_out, xor_out;

    // Compute the output for each operation
    assign and_out = in[3] & in[2] & in[1] & in[0];
    assign or_out = in[3] | in[2] | in[1] | in[0];
    assign xor_out = in[3] ^ in[2] ^ in[1] ^ in[0];

    // Use a conditional statement to select the output based on the operation
    always @(*)
    begin
        case (op)
            2'b00: out = and_out;
            2'b01: out = or_out;
            2'b10: out = xor_out;
            default: out = 1'b0; // Default to 0 for invalid operations
        endcase
    end

endmodule

// Top-level module instantiating the ParametricGate module
module TopModule(
    input  [3:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // Instantiate the ParametricGate module for each operation
    ParametricGate andGate(in, 2'b00, out_and);
    ParametricGate orGate(in, 2'b01, out_or);
    ParametricGate xorGate(in, 2'b10, out_xor);

endmodule