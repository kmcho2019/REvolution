module TopModule(
    input [2:0] in,
    output [1:0] out
);

    // Declare wires to hold individual contributions to the count
    wire [1:0] count_bit0;
    wire [1:0] count_bit1;
    wire [1:0] count_bit2;

    // Assign individual contributions to the count
    assign count_bit0 = {1'b0, in[0]};
    assign count_bit1 = {1'b0, in[1]};
    assign count_bit2 = {1'b0, in[2]};

    // Calculate the final output using the individual contributions
    assign out = count_bit0 + count_bit1 + count_bit2;

endmodule