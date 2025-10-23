module TopModule (
    input  [2:0] vec,
    output [2:0] outv,
    output       o2,
    output       o1,
    output       o0
);

    // Directly assign the output vector from the input vector
    assign outv = vec;

    // Declare an internal wire array to hold each split bit temporarily
    wire [2:0] bits;

    genvar i;
    generate
        for (i = 0; i < 3; i = i + 1) begin : bit_split
            assign bits[i] = vec[i];
        end
    endgenerate

    // Connect scalar outputs to corresponding bits
    assign o0 = bits[0];
    assign o1 = bits[1];
    assign o2 = bits[2];

endmodule