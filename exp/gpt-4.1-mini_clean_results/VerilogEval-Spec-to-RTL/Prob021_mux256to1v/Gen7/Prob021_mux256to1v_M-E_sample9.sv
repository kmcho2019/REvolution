module TopModule(
    input  [1023:0] in,
    input  [7:0]    sel,
    output [3:0]    out
);

    // Declare an array of 256 4-bit inputs unpacked from the wide input vector
    wire [3:0] in_words [0:255];

    genvar i;
    generate
        for (i=0; i<256; i=i+1) begin : unpack_loop
            assign in_words[i] = in[i*4 +: 4];
        end
    endgenerate

    // Select output directly from the array using 'sel' index
    assign out = in_words[sel];

endmodule