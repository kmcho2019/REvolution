module barrel_shifter(
    input [7:0] in,
    input [2:0] ctrl,
    output [7:0] out
);

    // Generate each output bit by selecting from rotated input
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : rotate_mux
            // For each output bit, select input bit (i + ctrl) mod 8
            assign out[i] = in[(i + ctrl) % 8];
        end
    endgenerate

endmodule