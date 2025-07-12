module TopModule (
    input  [2:0] in,
    output reg [1:0] out
);

    always @(*) begin
        // Calculate parity (LSB): XOR of all bits
        out[0] = in[0] ^ in[1] ^ in[2];

        // Calculate majority (MSB): true if at least two bits are set
        out[1] = (in[0] & in[1]) | (in[1] & in[2]) | (in[0] & in[2]);
    end

endmodule