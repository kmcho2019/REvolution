module ConfigurableRouter #(
    parameter NUM_INPUTS = 3,
    parameter NUM_OUTPUTS = 4,
    parameter ROUTING_CONFIG = 8'b0001_0010_0100
) (
    input [NUM_INPUTS-1:0] in,
    output [NUM_OUTPUTS-1:0] out
);
    // Routing configuration:
    // Each output gets 2 bits to select its input source
    // For this problem:
    // out[0] (w) = in[0] (a) - config 00
    // out[1] (x) = in[1] (b) - config 01
    // out[2] (y) = in[1] (b) - config 01
    // out[3] (z) = in[2] (c) - config 10

    genvar i;
    generate
        for (i = 0; i < NUM_OUTPUTS; i = i + 1) begin: output_routing
            case (ROUTING_CONFIG[i*2+:2])
                2'b00: assign out[i] = in[0];  // a -> w
                2'b01: assign out[i] = in[1];  // b -> x, b -> y
                2'b10: assign out[i] = in[2];  // c -> z
                default: assign out[i] = 1'b0;
            endcase
        end
    endgenerate
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
    wire [2:0] inputs = {c, b, a};
    wire [3:0] outputs;
    
    ConfigurableRouter #(
        .ROUTING_CONFIG(8'b0001_0010_0100)
    ) router (
        .in(inputs),
        .out(outputs)
    );
    
    assign {z, y, x, w} = outputs;
endmodule