module TopModule (
    input  [7:0] in,
    output [31:0] out
);
    // Sign-extend 8-bit input to 32-bit output by replicating MSB 24 times
    wire sign_bit = in[7];
    assign out = {{24{sign_bit}}, in};
endmodule