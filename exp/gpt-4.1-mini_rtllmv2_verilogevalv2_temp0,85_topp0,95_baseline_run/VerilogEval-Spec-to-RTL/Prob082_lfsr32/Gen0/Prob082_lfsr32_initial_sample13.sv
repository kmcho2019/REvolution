module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

    // Tap positions (1-based): 32, 22, 2, 1
    // Corresponding Verilog bit indices: 31, 21, 1, 0
    wire lsb = q[0];
    wire feedback;

    integer i;

    always @(posedge clk) begin
        if (reset) begin
            q <= 32'h1;
        end else begin
            // Compute next state
            // We'll build next_q bit by bit
            reg [31:0] next_q;
            next_q = 32'd0;

            // Bit 31 (tap)
            next_q[31] = q[31] ^ lsb;
            // Bits 30 down to 22 (no taps)
            for (i = 30; i > 21; i = i -1) begin
                next_q[i] = q[i+1];
            end
            // Bit 21 (tap)
            next_q[21] = q[21] ^ lsb;
            // Bits 20 down to 2 (no taps)
            for (i = 20; i > 1; i = i -1) begin
                next_q[i] = q[i+1];
            end
            // Bit 1 (tap)
            next_q[1] = q[1] ^ lsb;
            // Bit 0 (tap)
            next_q[0] = q[0] ^ lsb;

            // For bits that shift from q[i+1], but watch for i=31 (already assigned)
            // Actually, above assignments cover all bits except for bits 22 and 2:
            // bits 22 and 2 are not taps, so shift from q[23] and q[3]
            next_q[22] = q[23];
            next_q[2]  = q[3];

            q <= next_q;
        end
    end

endmodule