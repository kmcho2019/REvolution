module TopModule(
    input [2:0] in,
    output [1:0] out
);

    // Define internal signals for the binary counter tree
    wire [1:0] count0;
    wire [1:0] count1;

    // Compute the counts for each pair of input bits
    assign count0 = (in[0] == 1'b1) ? 2'b01 : 2'b00;
    assign count1 = (in[1] == 1'b1) ? 2'b01 : 2'b00;

    // Combine the counts using a binary counter tree structure
    assign out = count0 + count1 + (in[2] == 1'b1) ? 2'b01 : 2'b00;

endmodule