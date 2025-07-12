// Module to reverse the bit ordering of an 8-bit input
module TopModule(
    input  [7:0] in,  // 8-bit input vector
    output [7:0] out // 8-bit output vector
);

    // Using a generate block with a for loop to reverse the bits
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin
            // Assign the ith bit of out to the (7-i)th bit of in
            // This operation is straightforward and synthesizable, making it efficient for PPA metrics.
            assign out[i] = in[7-i];
        end
    endgenerate

endmodule