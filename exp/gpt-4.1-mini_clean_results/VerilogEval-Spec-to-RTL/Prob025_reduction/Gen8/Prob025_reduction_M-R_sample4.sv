module TopModule (
    input  [7:0] in,
    output reg   parity
);
    // Compute even parity using a combinational always block.
    // The parity output is updated whenever 'in' changes,
    // implementing the XOR reduction logic procedurally.
    always @(*) begin
        parity = in[0] ^ in[1] ^ in[2] ^ in[3] ^ in[4] ^ in[5] ^ in[6] ^ in[7];
    end
endmodule