module TopModule(
    input  [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    // Define neighbor indices for each output bit
    // For out_both: neighbor is left (higher index)
    localparam integer WIDTH = 4;
    genvar i;

    // Temporary wires to hold intermediate values
    wire [WIDTH-1:0] out_both_tmp;
    wire [WIDTH-1:0] out_any_tmp;
    wire [WIDTH-1:0] out_different_tmp;

    // Generate out_both:
    // For bits 0..2, check in[i] & in[i+1], for bit 3 no neighbor => 0
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin : gen_out_both
            if (i < WIDTH-1)
                assign out_both_tmp[i] = in[i] & in[i+1];
            else
                assign out_both_tmp[i] = 1'b0;
        end
    endgenerate

    // Generate out_any:
    // For bits 1..3, check in[i] | in[i-1], for bit 0 no neighbor => 0
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin : gen_out_any
            if (i > 0)
                assign out_any_tmp[i] = in[i] | in[i-1];
            else
                assign out_any_tmp[i] = 1'b0;
        end
    endgenerate

    // Generate out_different:
    // Each bit compares in[i] ^ in[(i+1)%WIDTH]
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin : gen_out_different
            // Wrap-around index for neighbor to left is (i+1) mod WIDTH
            localparam integer neighbor_idx = (i + 1) % WIDTH;
            assign out_different_tmp[i] = in[i] ^ in[neighbor_idx];
        end
    endgenerate

    // Assign outputs
    assign out_both      = out_both_tmp;
    assign out_any       = out_any_tmp;
    assign out_different = out_different_tmp;

endmodule