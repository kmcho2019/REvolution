module TopModule #(
    parameter NUM_SIGNALS = 3
)(
    input  [NUM_SIGNALS-1:0] inputs,
    output [NUM_SIGNALS-1:0] outputs
);

genvar i;
generate
    for (i = 0; i < NUM_SIGNALS; i++) begin
        assign outputs[i] = inputs[i];
    end
endgenerate

endmodule

module TopModuleWrapper(
    input  a,
    input  b,
    input  c,
    output w,
    output x,
    output y,
    output z
);

wire [3:0] inputs;
wire [3:0] outputs;

assign inputs[0] = a;
assign inputs[1] = b;
assign inputs[2] = b;
assign inputs[3] = c;

TopModule #(.NUM_SIGNALS(4)) top_module(
    .inputs(inputs),
    .outputs(outputs)
);

assign w = outputs[0];
assign x = outputs[1];
assign y = outputs[2];
assign z = outputs[3];

endmodule