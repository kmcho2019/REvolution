module TopModule (
    input  [2:0] in,
    output reg [1:0] out
);

    // Combinational logic for population count of 3-bit input
    always @(*) begin
        // Most significant bit: '1' if two or more inputs are '1'
        out[1] = (in[0] & in[1]) | (in[1] & in[2]) | (in[2] & in[0]);
        // Least significant bit: parity of the three inputs
        out[0] = in[0] ^ in[1] ^ in[2];
    end

endmodule