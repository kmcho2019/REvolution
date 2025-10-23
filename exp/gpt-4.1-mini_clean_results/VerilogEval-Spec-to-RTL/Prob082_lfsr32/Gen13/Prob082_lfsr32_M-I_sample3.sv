module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            q <= 32'h1;
        end else begin
            // Galois LFSR taps at bits 32, 22, 2, 1 (zero-based bits 31, 21, 1, 0)
            // q_next[31] = q[0] ^ q[31]
            // q_next[30:22] = q[31:23]
            // q_next[21] = q[0] ^ q[21]
            // q_next[20:2] = q[21:3]
            // q_next[1] = q[0] ^ q[1]
            // q_next[0] = q[0]

            q <= {
                q[0]   ^ q[31],       // bit 31
                q[30:22],             // bits 30 to 22
                q[0]   ^ q[21],       // bit 21
                q[20:2],              // bits 20 to 2
                q[0]   ^ q[1],        // bit 1
                q[0]                  // bit 0
            };
        end
    end

endmodule