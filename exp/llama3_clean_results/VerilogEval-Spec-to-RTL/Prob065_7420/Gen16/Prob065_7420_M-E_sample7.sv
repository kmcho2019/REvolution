// Define a parameterizable NAND gate module
module ParamNAND(
    parameter NUM_INPUTS = 4,
    input  [NUM_INPUTS-1:0] inputs,
    output y
);
// Initialize a wire to act as the accumulator for the AND operation
wire [NUM_INPUTS-1:0] and_result;

// Use a generate loop to AND all inputs together
genvar i;
generate
    assign and_result[0] = inputs[0];
    for (i = 1; i < NUM_INPUTS; i++) begin
        assign and_result[i] = and_result[i-1] & inputs[i];
    end
endgenerate

// Assign the final AND result to the output after negation
assign y = ~and_result[NUM_INPUTS-1];
endmodule

// Define the TopModule that instantiates two ParamNAND gates
module TopModule(
    input  p1a,
    input  p1b,
    input  p1c,
    input  p1d,
    input  p2a,
    input  p2b,
    input  p2c,
    input  p2d,
    output p1y,
    output p2y
);
// Instantiate two ParamNAND gates with 4 inputs each
ParamNAND nand1(
   .inputs({p1a, p1b, p1c, p1d}),
   .y(p1y)
);

ParamNAND nand2(
   .inputs({p2a, p2b, p2c, p2d}),
   .y(p2y)
);
endmodule