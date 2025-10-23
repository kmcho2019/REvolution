module TopModule(
    input  [7:0] in,
    output [31:0] out
);
    // Explicitly define the sign bit replication and concatenation
    assign out = { {24{in[7]}}, in };
endmodule