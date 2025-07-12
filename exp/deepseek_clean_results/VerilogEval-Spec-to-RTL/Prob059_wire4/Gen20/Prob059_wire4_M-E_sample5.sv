module ParametricWireRouter #(
    parameter INPUT_WIDTH = 3,
    parameter OUTPUT_WIDTH = 4,
    parameter ROUTING_MAP = 8'b0001_0010_0010_0000  // Maps outputs to inputs (4x2 bits)
) (
    input  [INPUT_WIDTH-1:0]  in,
    output [OUTPUT_WIDTH-1:0] out
);
    // For our specific case:
    // in[0] = a, in[1] = b, in[2] = c
    // out[0] = w, out[1] = x, out[2] = y, out[3] = z
    
    // Implement routing using the parameter
    assign out[0] = in[0];  // a -> w
    assign out[1] = in[1];  // b -> x
    assign out[2] = in[1];  // b -> y
    assign out[3] = in[2];  // c -> z
    
    // Note: The ROUTING_MAP parameter isn't actually used in this simple case,
    // but shows how we could extend this to more complex routing scenarios
endmodule

module TopModule (
    input  a,
    input  b,
    input  c,
    output w,
    output x,
    output y,
    output z
);
    wire [2:0] inputs = {c, b, a};  // Pack inputs
    wire [3:0] outputs;              // Will hold all outputs
    
    ParametricWireRouter #(
        .INPUT_WIDTH(3),
        .OUTPUT_WIDTH(4),
        .ROUTING_MAP(8'b0001_0010_0010_0000)
    ) router (
        .in(inputs),
        .out(outputs)
    );
    
    // Unpack outputs
    assign w = outputs[0];
    assign x = outputs[1];
    assign y = outputs[2];
    assign z = outputs[3];
endmodule