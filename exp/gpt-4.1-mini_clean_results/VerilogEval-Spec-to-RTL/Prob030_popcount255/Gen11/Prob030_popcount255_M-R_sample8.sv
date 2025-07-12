module popcount #(
    parameter WIDTH = 255
)(
    input  [WIDTH-1:0] in,
    output [$clog2(WIDTH+1)-1:0] out
);
    // Number of stages needed for the adder tree
    localparam STAGES = $clog2(WIDTH);
    // Width of partial sums at each stage: need enough bits to hold sum of up to WIDTH bits
    localparam SUM_WIDTH = $clog2(WIDTH+1);

    // Declare a two-dimensional array to hold the partial sums at each stage
    // Stage 0 holds individual input bits extended to SUM_WIDTH bits
    // Subsequent stages reduce the number of elements by half (rounded up)
    // Maximum array size is WIDTH at stage 0, halved each stage
    wire [SUM_WIDTH-1:0] sums [0:STAGES][0:WIDTH-1];

    genvar i, stage;

    // Stage 0: extend each input bit to SUM_WIDTH bits (0 or 1)
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin : stage0
            assign sums[0][i] = in[i];
        end
        // Fill unused elements with zero if any (for indexing convenience)
        for (i = WIDTH; i < WIDTH; i = i + 1) begin : stage0_unused
            assign sums[0][i] = {SUM_WIDTH{1'b0}};
        end
    endgenerate

    // Generate stages of addition: each stage sums pairs of elements from previous stage
    generate
        for (stage = 1; stage <= STAGES; stage = stage + 1) begin : stages
            // Number of elements at this stage (half of previous, rounded up)
            localparam int NUM_ELEMS = ( (WIDTH + (1 << stage) - 1) >> stage );
            for (i = 0; i < NUM_ELEMS; i = i + 1) begin : elems
                localparam int idx0 = i*2;
                localparam int idx1 = i*2 + 1;

                if (idx1 < ( (WIDTH + (1 << (stage-1)) - 1) >> (stage-1) )) begin
                    // Sum two elements from previous stage
                    assign sums[stage][i] = sums[stage-1][idx0] + sums[stage-1][idx1];
                end else begin
                    // If odd number, propagate last element up
                    assign sums[stage][i] = sums[stage-1][idx0];
                end
            end
            // Fill unused elements with zero (if any)
            for (i = NUM_ELEMS; i < WIDTH; i = i + 1) begin : elems_unused
                assign sums[stage][i] = {SUM_WIDTH{1'b0}};
            end
        end
    endgenerate

    // Final output is the single sum at the last stage index 0
    assign out = sums[STAGES][0];

endmodule

module TopModule (
    input  [254:0] in,
    output [7:0] out
);
    popcount #(.WIDTH(255)) u_popcount (
        .in(in),
        .out(out)
    );
endmodule