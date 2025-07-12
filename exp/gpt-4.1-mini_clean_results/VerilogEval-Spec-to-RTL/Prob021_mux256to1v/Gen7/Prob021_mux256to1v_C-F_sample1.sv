module TopModule(
    input  [1023:0] in,
    input  [7:0]    sel,
    output [3:0]    out
);

    // Represent input as array of 256 4-bit words for clean indexing
    wire [3:0] in_array [0:255];
    genvar i;
    generate
        for (i = 0; i < 256; i = i + 1) begin
            assign in_array[i] = in[4*i +: 4];
        end
    endgenerate

    // Directly assign output by indexing array with sel
    assign out = in_array[sel];

endmodule