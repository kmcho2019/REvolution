// Define a parameterizable gate module
module Gate(
    parameter GATE_TYPE = "AND", // OR, XOR
    parameter INPUT_WIDTH = 4,
    input [INPUT_WIDTH-1:0] in,
    output out
);

    generate
        if (GATE_TYPE == "AND") begin
            assign out = &in; // Reduction AND
        end else if (GATE_TYPE == "OR") begin
            assign out = |in; // Reduction OR
        end else if (GATE_TYPE == "XOR") begin
            assign out = ^in; // Reduction XOR
        end else begin
            $error("Invalid gate type. Supported types are AND, OR, XOR.");
        end
    endgenerate

endmodule

// Top-level module instantiating the gates
module TopModule(
    input [3:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    Gate andGate(.GATE_TYPE("AND"),.INPUT_WIDTH(4),.in(in),.out(out_and));
    Gate orGate(.GATE_TYPE("OR"),.INPUT_WIDTH(4),.in(in),.out(out_or));
    Gate xorGate(.GATE_TYPE("XOR"),.INPUT_WIDTH(4),.in(in),.out(out_xor));

endmodule