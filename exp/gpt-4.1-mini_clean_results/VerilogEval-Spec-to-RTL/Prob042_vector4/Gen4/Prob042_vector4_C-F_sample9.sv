module TopModule(
    input  [7:0] in,
    output [31:0] out
);
    // Sign-extend 8-bit input to 32 bits by replicating MSB 24 times and concatenating with input
    assign out = {{24{in[7]}}, in};

endmodule