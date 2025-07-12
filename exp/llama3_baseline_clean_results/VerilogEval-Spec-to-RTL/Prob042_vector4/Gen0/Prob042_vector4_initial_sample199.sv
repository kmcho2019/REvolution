module TopModule(
    input  [7:0] in,  // 8-bit input
    output [31:0] out  // 32-bit output
);

// Sign bit replication and concatenation
assign out = {24{in[7]}, in};

endmodule