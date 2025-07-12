module TopModule(
    input [7:0] in,
    output [31:0] out
);
    
    // Replicate the sign bit 24 times and concatenate with the original 8-bit number
    assign out = { {24{in[7]}}, in };
    
endmodule