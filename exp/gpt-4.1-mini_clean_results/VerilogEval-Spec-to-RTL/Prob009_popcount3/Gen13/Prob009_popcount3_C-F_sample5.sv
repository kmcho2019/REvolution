module TopModule (
    input  [2:0] in,
    output reg [1:0] out
);

    always @(*) begin
        // out[0]: parity of the three bits (XOR of all bits)
        out[0] = in[0] ^ in[1] ^ in[2];

        // out[1]: majority function - set if at least two inputs are high
        out[1] = (in[0] & in[1]) | (in[1] & in[2]) | (in[2] & in[0]);
    end

endmodule