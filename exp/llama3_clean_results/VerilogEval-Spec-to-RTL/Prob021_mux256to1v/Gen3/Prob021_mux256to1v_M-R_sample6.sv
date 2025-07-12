module TopModule(
    input  [1023:0] in,
    input  [7:0] sel,
    output [3:0] out
);

    // Calculate the offset within the 1024-bit vector based on the select signal
    wire [9:0] offset = {sel[7:4], sel[3:0]} * 4;

    // Directly extract the 4-bit output from the input vector using the calculated offset
    assign out = in[offset +: 4];

endmodule