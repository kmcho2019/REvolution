module TopModule(
    input wire [7:0] in,
    output wire [31:0] out
);

    // Directly assign the result of sign extension to the output
    assign out = {24{in[7]}, in};

endmodule