module TopModule (
    input  wire [1023:0] in,
    input  wire [7:0]    sel,
    output wire [3:0]    out
);

    // Declare an array of 256 4-bit elements, each corresponding to 4 bits of 'in'
    wire [3:0] in_array [0:255];

    genvar i;
    generate
        for (i = 0; i < 256; i = i + 1) begin : input_unpack
            assign in_array[i] = in[i*4 +: 4];
        end
    endgenerate

    // Use sel as an index to select one 4-bit element from the array
    assign out = in_array[sel];

endmodule