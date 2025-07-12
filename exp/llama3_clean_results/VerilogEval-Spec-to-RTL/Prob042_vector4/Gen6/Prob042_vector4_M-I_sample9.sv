module TopModule(
    input wire [7:0] in,
    output wire [31:0] out
);
    // The replication operator {24{in[7]}} replicates the sign bit (in[7]) 24 times,
    // and this is concatenated with the 8-bit input 'in' to achieve the sign extension.
    assign out = {24{in[7]}, in};
endmodule