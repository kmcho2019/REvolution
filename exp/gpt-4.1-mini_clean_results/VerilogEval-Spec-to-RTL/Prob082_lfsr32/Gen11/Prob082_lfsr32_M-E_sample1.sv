module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

    // Tap positions (0-based): 31, 21, 1, 0
    // On shift right: q[i] <= q[i+1] XOR q[0] if tap else q[i+1]
    // For MSB (bit 31), next bit is q[0] XOR 0 since no q[32], we handle taps carefully.

    integer i;
    reg [31:0] next_q;

    always @(*) begin
        next_q = 32'b0;
        // Bit 31 (MSB) next is q[0] XOR 0 if tap (which it is at bit 31), so next_q[31] = q[0]
        next_q[31] = q[0]; 

        // Bits 30 down to 22: no taps except bit 21
        for (i = 30; i > 21; i = i - 1) begin
            next_q[i] = q[i+1];
        end

        // Bit 21 is a tap, so XOR with q[0]
        next_q[21] = q[22] ^ q[0];

        // Bits 20 down to 2: no taps except bit 1
        for (i = 20; i > 1; i = i - 1) begin
            next_q[i] = q[i+1];
        end

        // Bit 1 is a tap
        next_q[1] = q[2] ^ q[0];

        // Bit 0 is a tap, next_q[0] = q[1] ^ q[0]
        next_q[0] = q[1] ^ q[0];
    end

    always @(posedge clk) begin
        if (reset)
            q <= 32'h1;
        else
            q <= next_q;
    end

endmodule