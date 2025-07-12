module TopModule #(
    parameter WIDTH = 100
) (
    input  [WIDTH-1:0] in,
    output [WIDTH-1:0] out
);

    // Define the number of stages required for the bit reversal
    localparam NUM_STAGES = $clog2(WIDTH);

    // Define the wires for each stage
    wire [WIDTH-1:0] stage_out [NUM_STAGES];

    // Initialize the first stage with the input
    assign stage_out[0] = in;

    // Generate the stages for the bit reversal
    genvar i;
    generate
        for (i = 1; i <= NUM_STAGES; i++) begin
            // Define the wires for the current stage
            wire [WIDTH-1:0] stage_in;
            assign stage_in = stage_out[i-1];

            // Generate the multiplexers for the current stage
            genvar j;
            generate
                for (j = 0; j < WIDTH; j++) begin
                    // Calculate the position of the bit in the current stage
                    localparam BIT_POS = j ^ (1 << (i-1));

                    // Assign the output of the current stage
                    assign stage_out[i][j] = stage_in[BIT_POS];
                end
            endgenerate
        end
    endgenerate

    // Assign the final output
    assign out = stage_out[NUM_STAGES];

endmodule