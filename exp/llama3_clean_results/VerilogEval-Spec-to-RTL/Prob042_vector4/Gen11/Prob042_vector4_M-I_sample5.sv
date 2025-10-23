module TopModule (
    input [7:0] in,
    output [31:0] out
);

    // Directly using the replication operator to sign-extend the input
    assign out = { {24{in[7]}}, in };

endmodule