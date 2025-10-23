module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);

    wire [4:0] inputs = {a, b, c, d, e};
    genvar i, j;
    wire [24:0] temp_out;

    generate
        for (i = 0; i < 5; i = i + 1) begin : i_loop
            for (j = 0; j < 5; j = j + 1) begin : j_loop
                // Compute index in out vector (descending order)
                // out[24] = (i=0, j=0), out[23] = (0,1), ..., out[0] = (4,4)
                localparam integer idx = 24 - (i*5 + j);
                assign temp_out[idx] = ~(inputs[i] ^ inputs[j]);
            end
        end
    endgenerate

    assign out = temp_out;

endmodule