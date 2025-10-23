module TopModule(
    input  [7:0] in,
    output reg [31:0] out
);
    wire sign_bit = in[7];

    always @(*) begin
        // Sign-extend 8-bit input to 32 bits by replicating the sign bit 24 times
        // followed by the original 8 bits, preserving the signed value.
        out = { {24{sign_bit}}, in };
    end
endmodule