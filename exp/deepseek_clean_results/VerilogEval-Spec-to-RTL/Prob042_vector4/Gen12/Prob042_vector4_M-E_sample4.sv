module TopModule (
    input  [7:0] in,
    output [31:0] out
);
    // Sign extension via pattern selection
    wire [23:0] extension = {24{in[7]}};  // Implicit replication through wire assignment
    assign out = {extension, in};
endmodule