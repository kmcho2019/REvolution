module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            q <= 32'h1;
        end else begin
            // Compute next state explicitly for each bit according to Galois LFSR taps
            q <= {
                q[0] ^ q[31],  // bit 31 (tap at 32)
                q[31:22] ^ {10{q[0]}}, // bits 30 down to 21: bit 21 tapped, so only bit 21 XOR q[0]
                q[21] ^ q[0],          // bit 21 tap (bit 22)
                q[20:2],               // bits 20 down to 2 no tap, just shift
                q[1] ^ q[0],           // bit 1 tap (bit 2)
                q[0]                   // bit 0 tap (bit 1)
            };
        end
    end

endmodule