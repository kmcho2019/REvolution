module TopModule #(
    parameter NUM_INPUTS = 3,
    parameter NUM_OUTPUTS = 4
)(
    input  [NUM_INPUTS-1:0] inputs,
    output [NUM_OUTPUTS-1:0] outputs
);

    assign outputs[0] = inputs[0]; // a -> w
    assign outputs[1] = inputs[1]; // b -> x
    assign outputs[2] = inputs[1]; // b -> y
    assign outputs[3] = inputs[2]; // c -> z

endmodule