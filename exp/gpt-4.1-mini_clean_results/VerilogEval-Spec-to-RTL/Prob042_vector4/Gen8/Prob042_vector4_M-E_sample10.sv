module TopModule (
    input  [7:0] in,
    output reg [31:0] out
);
    always @(*) begin
        // Shift input to the left so that in[7] is in MSB of 32 bits
        // Then arithmetic right shift to replicate the sign bit
        // Shift left by (32-8)=24 bits, then arithmetic shift right by 24 bits
        out = $signed(in) <<< 24;       // Shift left to position sign bit at MSB
        out = $signed(out) >>> 24;      // Arithmetic shift right to sign-extend
    end
endmodule