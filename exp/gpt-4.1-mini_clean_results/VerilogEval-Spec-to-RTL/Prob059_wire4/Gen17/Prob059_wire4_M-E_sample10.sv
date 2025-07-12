module TopModule (
    input  wire a,
    input  wire b,
    input  wire c,
    output wire w,
    output wire x,
    output wire y,
    output wire z
);

    // Internal bus grouping inputs
    wire [2:0] input_bus;
    assign input_bus = {a, b, c}; // input_bus[2]=a, [1]=b, [0]=c

    // Map outputs from input bus signals
    assign w = input_bus[2]; // a -> w
    assign x = input_bus[1]; // b -> x
    assign y = input_bus[1]; // b -> y
    assign z = input_bus[0]; // c -> z

endmodule