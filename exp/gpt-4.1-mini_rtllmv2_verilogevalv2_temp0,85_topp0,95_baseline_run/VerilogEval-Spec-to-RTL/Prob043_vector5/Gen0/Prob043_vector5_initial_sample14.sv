module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);

    wire [4:0] inputs = {a, b, c, d, e};
    // We'll map the 5 inputs into an array for easy indexing
    // Since inputs[4] = a, inputs[3] = b, etc. Let's reorder so inputs[0]=a for easier indexing:
    wire [4:0] in_arr = {a, b, c, d, e};
    // Actually to be consistent, let's assign names to indices:
    // a->0, b->1, c->2, d->3, e->4

    // We'll compute out[24 - (5*i + j)] = (inputs[i] XNOR inputs[j])
    // That means: out[24] = i=0,j=0 (a,a)
    //             out[23] = i=0,j=1 (a,b)
    //             ...
    //             out[0] = i=4,j=4 (e,e)

    genvar i, j;
    generate
        for (i=0; i<5; i=i+1) begin : row
            for (j=0; j<5; j=j+1) begin : col
                // Calculate the output bit index
                localparam integer idx = 24 - (5*i + j);
                // Access inputs as in_arr[index]
                wire bit_i = in_arr[4 - i]; // since MSB is a, at position 4
                wire bit_j = in_arr[4 - j];
                assign out[idx] = ~(bit_i ^ bit_j); // XNOR
            end
        end
    endgenerate

endmodule