module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

    wire [31:0] next_q;
    integer i;

    // Tap positions zero-indexed: 31 (bit 32), 21 (bit 22), 1 (bit 2), 0 (bit 1)
    // For Galois LFSR, each bit gets next value = current bit shifted right, and
    // if q[0] = 1, certain taps are XORed in the feedback path.

    // next_q[31] = q[0] xor q[31] (since MSB gets feedback)
    // next_q[i] = q[i+1] xor (q[0] & tap[i]) for i=0..30

    // Define taps as a constant vector
    localparam [31:0] TAP_MASK = (1 << 31) | (1 << 21) | (1 << 1) | (1 << 0);

    assign next_q[31] = q[0] ^ q[31];
    // For bits 30 down to 0
    generate
        genvar idx;
        for (idx = 0; idx < 31; idx = idx + 1) begin : gen_lfsr_bits
            assign next_q[idx] = q[idx+1] ^ (q[0] & TAP_MASK[idx]);
        end
    endgenerate

    always @(posedge clk) begin
        if (reset)
            q <= 32'h1;
        else
            q <= next_q;
    end

endmodule