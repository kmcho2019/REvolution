module MultiConcat #(
    parameter WIDTH = 5,        // Width of each input vector
    parameter NUM_INPUTS = 6    // Number of inputs to concatenate
) (
    input  [WIDTH-1:0] in0,
    input  [WIDTH-1:0] in1,
    input  [WIDTH-1:0] in2,
    input  [WIDTH-1:0] in3,
    input  [WIDTH-1:0] in4,
    input  [WIDTH-1:0] in5,
    output [(WIDTH*NUM_INPUTS)-1:0] out
);
    // Concatenate all six input vectors into one wide output vector
    assign out = {in0, in1, in2, in3, in4, in5};
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

    wire [29:0] concatenated_inputs;

    // Instantiate MultiConcat to concatenate all six 5-bit inputs into 30 bits
    MultiConcat #(.WIDTH(5), .NUM_INPUTS(6)) mc (
        .in0(a),
        .in1(b),
        .in2(c),
        .in3(d),
        .in4(e),
        .in5(f),
        .out(concatenated_inputs)
    );

    // Append two LSB '1' bits to make a 32-bit combined vector
    wire [31:0] combined = {concatenated_inputs, 2'b11};

    // Split the combined 32-bit vector into four 8-bit outputs
    assign w = combined[31:24];
    assign x = combined[23:16];
    assign y = combined[15:8];
    assign z = combined[7:0];

endmodule