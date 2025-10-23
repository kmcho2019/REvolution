module TopModule (
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // Configurable parameters
    localparam TOTAL_WIDTH = 100;
    localparam SEGMENT_SIZE = 25;
    localparam NUM_SEGMENTS = TOTAL_WIDTH / SEGMENT_SIZE;

    // Segment reduction wires
    wire [NUM_SEGMENTS-1:0] seg_and, seg_or;

    // Generate segment reductions
    generate
        for (genvar i = 0; i < NUM_SEGMENTS; i = i + 1) begin : segment_reduction
            localparam MSB = (i+1)*SEGMENT_SIZE - 1;
            localparam LSB = i*SEGMENT_SIZE;
            assign seg_and[i] = &in[MSB:LSB];
            assign seg_or[i]  = |in[MSB:LSB];
        end
    endgenerate

    // Final outputs
    assign out_and = &seg_and;
    assign out_or  = |seg_or;
    assign out_xor = ^in;  // Optimal XOR implementation

endmodule