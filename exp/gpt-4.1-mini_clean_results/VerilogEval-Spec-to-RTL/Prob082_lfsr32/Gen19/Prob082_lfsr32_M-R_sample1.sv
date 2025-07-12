module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

    wire feedback = q[0];
    reg [31:0] next_q;

    always @* begin
        // Bit 31 (MSB) gets feedback
        next_q[31] = feedback;
        // Bits 30 down to 22 shift right by one bit
        next_q[30:22] = q[31:23];
        // Tap at bit 22 (idx 21): xor with feedback
        next_q[21] = q[22] ^ feedback;
        // Bits 20 down to 2 shift right by one bit
        next_q[20:2] = q[21:3];
        // Tap at bit 2 (idx 1): xor with feedback
        next_q[1] = q[2] ^ feedback;
        // Tap at bit 1 (idx 0): xor with feedback
        next_q[0] = q[1] ^ feedback;
    end

    always @(posedge clk) begin
        if (reset) 
            q <= 32'h1;
        else 
            q <= next_q;
    end

endmodule