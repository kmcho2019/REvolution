module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

    always @(posedge clk) begin
        if (reset)
            q <= 32'h1;
        else begin
            // feedback bit is q[0]
            // shift right by 1, then XOR taps with feedback bit
            q <= {q[0] ^ q[31], q[31:1]} ^ ({32{q[0]}} & (32'h00400006));
            // Explanation: 
            // Bit 31 next = q[0] xor q[31]
            // Other taps at bits 21 (bit 22-1), 1 (bit 2-1), and 0 (bit 1-1) are XORed using mask 0x00400006 shifted accordingly
            // Alternatively, the mask 0x00400006 corresponds to bits 22, 2, and 1 tapped (bits 21,1,0 zero-based)
        end
    end

endmodule