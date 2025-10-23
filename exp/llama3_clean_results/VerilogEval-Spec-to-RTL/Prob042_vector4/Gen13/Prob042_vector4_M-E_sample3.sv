module TopModule (
    input [7:0] in,
    output [31:0] out
);

    // Conditional assignment based on the MSB
    assign out = (in[7] == 1'b1) ? {24{1'b1}, in} : {24{1'b0}, in};

endmodule