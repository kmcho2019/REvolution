module TopModule(
    input  wire [99:0] in,
    output wire [99:0] out_both,
    output wire [99:0] out_any,
    output wire [99:0] out_different
);

    // Constants for width
    localparam WIDTH = 100;

    genvar i;

    // out_both[i]: 1 if in[i] & in[i+1], for i=0..98; out_both[99] = 0 since no left neighbor
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin : gen_out_both
            if (i == WIDTH - 1) begin
                assign out_both[i] = 1'b0;
            end else begin
                assign out_both[i] = in[i] & in[i+1];
            end
        end
    endgenerate

    // out_any[i]: 1 if in[i] | in[i-1], for i=1..99; out_any[0] = 0 since no right neighbor
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin : gen_out_any
            if (i == 0) begin
                assign out_any[i] = 1'b0;
            end else begin
                assign out_any[i] = in[i] | in[i-1];
            end
        end
    endgenerate

    // out_different[i]: 1 if in[i] != neighbor to the left with wrap-around
    // For i=0 neighbor to left is in[99], for others in[i-1]
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin : gen_out_different
            if (i == 0) begin
                assign out_different[i] = in[0] ^ in[WIDTH-1];
            end else begin
                assign out_different[i] = in[i] ^ in[i-1];
            end
        end
    endgenerate

endmodule