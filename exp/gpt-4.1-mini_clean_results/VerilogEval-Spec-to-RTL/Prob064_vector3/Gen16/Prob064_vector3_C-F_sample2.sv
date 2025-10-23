module MultiConcat #(
    parameter WIDTH = 5,        // Width of each input vector
    parameter NUM_INPUTS = 6    // Number of inputs to concatenate
) (
    input  [WIDTH-1:0] in [NUM_INPUTS-1:0],
    output [(WIDTH*NUM_INPUTS)-1:0] out
);
    // Generate concatenation of all inputs in order from in[0] (MSBs) to in[NUM_INPUTS-1] (LSBs)
    assign out = {in[0], in[1], in[2], in[3], in[4], in[5]};
endmodule

module TopModule (
    input  [4:0] a,
    input  [4:0] b,
    input  [4:0] c,
    input  [4:0] d,
    input  [4:0] e,
    input  [4:0] f,
    output [7:0] w,
    output [7:0] x,
    output [7:0] y,
    output [7:0] z
);

    // Pack inputs into an array to use MultiConcat
    wire [4:0] inputs_array [5:0];
    assign inputs_array[0] = a;
    assign inputs_array[1] = b;
    assign inputs_array[2] = c;
    assign inputs_array[3] = d;
    assign inputs_array[4] = e;
    assign inputs_array[5] = f;

    wire [29:0] concatenated_inputs;

    // Instantiate MultiConcat to concatenate all six inputs
    MultiConcat #(.WIDTH(5), .NUM_INPUTS(6)) concat6 (
        .in(inputs_array),
        .out(concatenated_inputs)
    );

    // Append two constant 1 bits to form 32-bit combined vector
    wire [31:0] combined = {concatenated_inputs, 2'b11};

    // Split combined vector into four 8-bit outputs
    assign w = combined[31:24];
    assign x = combined[23:16];
    assign y = combined[15:8];
    assign z = combined[7:0];

endmodule