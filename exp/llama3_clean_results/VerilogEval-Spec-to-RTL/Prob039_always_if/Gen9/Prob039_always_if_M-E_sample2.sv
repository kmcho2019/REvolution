// Define a generic, parameterizable multiplexer module
module GenericMultiplexer #(
    parameter INPUT_WIDTH = 1,  // Width of each input
    parameter NUM_INPUTS = 2,   // Number of input signals
    parameter NUM_SELECT_LINES = 2  // Number of select lines
)(
    input [NUM_SELECT_LINES-1:0] sel,
    input [INPUT_WIDTH-1:0] inputs [NUM_INPUTS-1:0],
    output [INPUT_WIDTH-1:0] out_assign,
    output logic [INPUT_WIDTH-1:0] out_always
);

// Use assign statement for direct assignment
assign out_assign = (sel == {NUM_SELECT_LINES{1'b1}}) ? inputs[1] : inputs[0];

// Use always block for procedural assignment
always @(*) begin
    out_always = (sel == {NUM_SELECT_LINES{1'b1}}) ? inputs[1] : inputs[0];
end

endmodule

// The top module instantiates the generic multiplexer module
module TopModule(
    input  a,
    input  b,
    input  sel_b1,
    input  sel_b2,
    output out_assign,
    output logic out_always
);

// Instantiate the generic multiplexer module with appropriate parameters
GenericMultiplexer #(
    .INPUT_WIDTH(1),
    .NUM_INPUTS(2),
    .NUM_SELECT_LINES(2)
) generic_multiplexer(
    .sel({sel_b2, sel_b1}),  // Select lines
    .inputs({b, a}),  // Input signals
    .out_assign(out_assign),
    .out_always(out_always)
);

endmodule