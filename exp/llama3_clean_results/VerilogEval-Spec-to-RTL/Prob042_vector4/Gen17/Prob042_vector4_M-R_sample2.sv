module TopModule (
    input [7:0] in,
    output [31:0] out
);

    // Assign the replicated MSB concatenated with the input to the output
    assign out = (in[7]? 32'b1 : 32'b0) & { {24{1'b1}}, in };

endmodule