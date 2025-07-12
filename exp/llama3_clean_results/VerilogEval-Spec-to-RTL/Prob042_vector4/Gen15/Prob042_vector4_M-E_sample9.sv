module TopModule (
    input [7:0] in,
    output [31:0] out
);

    // Create a mask with 24 ones for the most significant bits
    wire [31:0] mask = {24{1'b1}}, {8{1'b0}};

    // Conditionally apply the mask based on the sign bit of the input
    assign out = (in[7] == 1'b1) ? (mask | {24{1'b0}}, in) : {24{1'b0}}, in;

endmodule