module TopModule (
    input  [2:0] vec,
    output [2:0] outv,
    output       o2,
    output       o1,
    output       o0
);

    assign outv = vec;

    // Intermediate wires to hold bits, created with a generate block
    wire [2:0] bits;

    genvar i;
    generate
        for (i = 0; i < 3; i = i + 1) begin : BIT_SPLIT
            assign bits[i] = vec[i];
        end
    endgenerate

    // Assign each output to the corresponding bit of bits vector
    assign o0 = bits[0];
    assign o1 = bits[1];
    assign o2 = bits[2];

endmodule