module TopModule (
    input [7:0] in,
    output [31:0] out
);

    // Directly assign the replicated MSB and the input to the output
    // Using a more explicit replication to potentially help synthesis tools
    assign out = { 24{in[7]}, in };

endmodule