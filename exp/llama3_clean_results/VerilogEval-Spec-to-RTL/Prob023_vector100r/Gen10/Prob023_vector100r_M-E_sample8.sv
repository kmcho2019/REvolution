module TopModule #(
    parameter WIDTH = 100
) (
    input  [WIDTH-1:0] in,
    output [WIDTH-1:0] out
);

    // Calculate the number of stages required for the barrel shifter
    localparam NUM_STAGES = $clog2(WIDTH);

    // Internal wires for each stage
    wire [WIDTH-1:0] stage_out [NUM_STAGES];

    // Assign the input to the first stage
    assign stage_out[0] = in;

    // Generate each stage of the barrel shifter
    genvar i;
    generate
        for (i = 1; i <= NUM_STAGES; i++) begin
            // Calculate the swap mask for this stage
            localparam SWAP_MASK = (1 << (1 << (i - 1))) - 1;

            // Perform the swap operation for this stage
            assign stage_out[i] = {stage_out[i-1][WIDTH-1-SWAP_MASK:0], stage_out[i-1][WIDTH-1:WIDTH-SWAP_MASK]};
        end
    endgenerate

    // Assign the output of the final stage to the output
    assign out = stage_out[NUM_STAGES];

endmodule