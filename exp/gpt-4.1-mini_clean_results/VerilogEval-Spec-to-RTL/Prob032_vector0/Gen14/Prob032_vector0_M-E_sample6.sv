module TopModule (
    input  [2:0] vec,
    output [2:0] outv,
    output       o2,
    output       o1,
    output       o0
);
    // Intermediate wires to hold single-bit outputs indexed by generate
    wire [2:0] bits;

    // Assign outv directly from vec
    assign outv = vec;

    genvar i;
    generate
        for (i = 0; i < 3; i = i + 1) begin : bit_assign
            // Assign each bit of vec to the bits array
            assign bits[i] = vec[i];
        end
    endgenerate

    // Map bits from bits[] wire to output ports
    assign o0 = bits[0];
    assign o1 = bits[1];
    assign o2 = bits[2];

endmodule