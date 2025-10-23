module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

    wire feedback = q[0];
    reg [31:0] next_q;

    always @(*) begin
        // Update bits from MSB down to LSB
        // Taps at bit positions 31, 21, 1, and 0 (0-based)
        // Bit 31
        next_q[31] = q[31-1] ^ (feedback & 1'b1);       // tap at 31
        // Bit 30 down to 22 (no taps except 21)
        integer i;
        for (i = 30; i > 21; i = i -1)
            next_q[i] = q[i-1];
        // Bit 21 tap
        next_q[21] = q[20] ^ (feedback & 1'b1);
        // Bits 20 down to 2 no taps except 1
        for (i = 20; i > 1; i = i -1)
            next_q[i] = q[i-1];
        // Bit 1 tap
        next_q[1] = q[0] ^ (feedback & 1'b1);
        // Bit 0 tap
        next_q[0] = feedback;
    end

    always @(posedge clk) begin
        if (reset) 
            q <= 32'h1;
        else 
            q <= next_q;
    end

endmodule