module TopModule(
    input  [7:0] in,
    output [7:0] out
);

    // Using a barrel shifter-like approach with multiplexers
    assign out[0] = in[7];
    assign out[1] = in[6];
    assign out[2] = in[5];
    assign out[3] = in[4];
    assign out[4] = in[3];
    assign out[5] = in[2];
    assign out[6] = in[1];
    assign out[7] = in[0];

    // Alternatively, using a for loop for more scalability
    // genvar i;
    // generate
    //     for (i = 0; i < 8; i = i + 1) begin
    //         assign out[i] = in[7-i];
    //     end
    // endgenerate

endmodule