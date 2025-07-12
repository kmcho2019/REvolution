module min2(
    input  [7:0] x,
    input  [7:0] y,
    output [7:0] z
);
    assign z = (x < y) ? x : y;
endmodule

module TopModule(
    input  [7:0] a,
    input  [7:0] b,
    input  [7:0] c,
    input  [7:0] d,
    output [7:0] min
);
    // Pack inputs into an array for indexed access and scalable handling
    wire [7:0] vals [0:3];
    assign vals[0] = a;
    assign vals[1] = b;
    assign vals[2] = c;
    assign vals[3] = d;

    // Stage 1 wires: min between pairs of inputs
    wire [7:0] stage1 [0:1];

    genvar i;
    generate
        // Compare vals[2*i] and vals[2*i+1] to get stage1[i]
        for (i = 0; i < 2; i = i + 1) begin : gen_stage1
            min2 cmp (
                .x(vals[2*i]),
                .y(vals[2*i + 1]),
                .z(stage1[i])
            );
        end
    endgenerate

    // Final stage: min between the two stage1 results
    min2 cmp_final(
        .x(stage1[0]),
        .y(stage1[1]),
        .z(min)
    );

endmodule