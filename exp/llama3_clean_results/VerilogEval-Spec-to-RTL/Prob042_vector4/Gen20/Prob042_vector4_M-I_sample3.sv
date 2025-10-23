module TopModule (
    input [7:0] in,
    output [31:0] out
);

    // Create a mask to sign-extend the input
    assign out = (in[7] == 1'b1)? {24{1'b1}, in} : {24{1'b0}, in};

    // Alternatively, the above line can be replaced with:
    // assign out = (in[7]? -1 : 0) + {24{1'b0}, in};

endmodule