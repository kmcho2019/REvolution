module TopModule (
    input  [2:0] vec,
    output [2:0] outv,
    output       o2,
    output       o1,
    output       o0
);
    // Directly assign outv as the input vector for minimal overhead
    assign outv = vec;

    // Use a generate block to assign individual bits to outputs compactly
    // Create an internal wire array for clarity and scalable indexing
    wire [2:0] bits;
    genvar i;
    generate
        for (i = 0; i < 3; i = i + 1) begin : bit_extract
            assign bits[i] = vec[i];
        end
    endgenerate

    // Connect output ports to corresponding bits
    assign o0 = bits[0];
    assign o1 = bits[1];
    assign o2 = bits[2];

endmodule