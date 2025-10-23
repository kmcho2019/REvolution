module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            q <= 32'h1;
        end else begin
            // Compute feedback bit (lsb)
            wire feedback = q[0];
            q[31] <= q[31] ^ feedback;        // tap at bit 31 (32)
            
            // Next state computation following Galois LFSR style:
            q <= {
                (q[31] ^ feedback),          // bit 31 (msb) next = q[31]^feedback
                q[31:22],                   // bits 30..22 shift right (no tap)
                q[21] ^ feedback,           // bit 21 tap XOR feedback
                q[20:2],                    // bits 20..2 shift right
                q[1] ^ feedback,            // bit 1 tap XOR feedback
                q[0] ^ feedback             // bit 0 tap XOR feedback (the LSB is also tapped here)
            };
        end
    end

endmodule