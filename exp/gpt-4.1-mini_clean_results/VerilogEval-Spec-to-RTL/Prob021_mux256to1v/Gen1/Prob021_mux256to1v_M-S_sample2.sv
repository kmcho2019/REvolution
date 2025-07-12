module TopModule(
    input  [1023:0] in,
    input  [7:0]    sel,
    output [3:0]    out
);

    // Treat input as an array of 256 4-bit elements
    wire [3:0] in_array [0:255];

    genvar i;
    generate
        for (i = 0; i < 256; i = i + 1) begin
            assign in_array[i] = in[4*i +: 4];
        end
    endgenerate

    assign out = in_array[sel];

endmodule