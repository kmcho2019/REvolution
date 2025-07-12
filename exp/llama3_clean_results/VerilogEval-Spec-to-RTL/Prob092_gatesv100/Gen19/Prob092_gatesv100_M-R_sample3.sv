module TopModule(
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    genvar i;
    generate
        for (i = 0; i < 100; i = i + 1) begin
            wire left_neighbor;
            assign left_neighbor = (i == 99)? 1'b0 : in[i+1];
            assign out_both[i] = in[i] & left_neighbor;

            wire right_neighbor;
            assign right_neighbor = (i == 0)? 1'b0 : in[i-1];
            assign out_any[i] = in[i] | right_neighbor;

            assign out_different[i] = in[i] ^ in[(i+1) % 100];
        end
    endgenerate

endmodule