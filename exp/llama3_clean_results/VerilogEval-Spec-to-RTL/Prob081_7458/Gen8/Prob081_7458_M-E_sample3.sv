// Parameterizable Universal Gate module
module UniversalGate(
    parameter GATE_TYPE = "AND", // "AND" or "OR"
    parameter NUM_INPUTS = 2,    // Number of inputs to the gate
    input [NUM_INPUTS-1:0] inputs,
    output y
);
    wire [NUM_INPUTS-1:0] inverted_inputs;

    // Invert inputs for OR gate (since OR is implemented using NAND)
    genvar i;
    generate
        for (i = 0; i < NUM_INPUTS; i++) begin
            if (GATE_TYPE == "OR") begin
                assign inverted_inputs[i] = ~inputs[i];
            end else begin
                assign inverted_inputs[i] = inputs[i];
            end
        end
    endgenerate

    // AND (or NAND for OR gate) all inputs together
    assign y = (GATE_TYPE == "AND") ? &inputs : ~(|inverted_inputs);
endmodule

// TopModule using the UniversalGate
module TopModule(
    input p1a,
    input p1b,
    input p1c,
    input p1d,
    input p1e,
    input p1f,
    input p2a,
    input p2b,
    input p2c,
    input p2d,
    output p1y,
    output p2y
);
    wire and1_out, and2_out, and3_out, and4_out;

    // 3-input AND gates
    UniversalGate #(.GATE_TYPE("AND"), .NUM_INPUTS(3)) and1(
        .inputs({p1a, p1b, p1c}),
        .y(and1_out)
    );
    UniversalGate #(.GATE_TYPE("AND"), .NUM_INPUTS(3)) and2(
        .inputs({p1d, p1e, p1f}),
        .y(and2_out)
    );

    // 2-input AND gates
    UniversalGate #(.GATE_TYPE("AND"), .NUM_INPUTS(2)) and3(
        .inputs({p2a, p2b}),
        .y(and3_out)
    );
    UniversalGate #(.GATE_TYPE("AND"), .NUM_INPUTS(2)) and4(
        .inputs({p2c, p2d}),
        .y(and4_out)
    );

    // OR gates
    UniversalGate #(.GATE_TYPE("OR"), .NUM_INPUTS(2)) or1(
        .inputs({and1_out, and2_out}),
        .y(p1y)
    );
    UniversalGate #(.GATE_TYPE("OR"), .NUM_INPUTS(2)) or2(
        .inputs({and3_out, and4_out}),
        .y(p2y)
    );
endmodule