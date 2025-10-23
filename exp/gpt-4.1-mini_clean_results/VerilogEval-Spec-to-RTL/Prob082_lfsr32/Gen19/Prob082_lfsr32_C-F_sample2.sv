module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

    wire feedback = q[0];

    always @(posedge clk) begin
        if (reset) begin
            q <= 32'h1;
        end else begin
            // MSB is feedback
            q[31] <= feedback;
            // Bits 30 down to 22 shift right without change
            q[30:22] <= q[31:23];
            // Tap at bit 22 (idx 21): XOR with feedback
            q[21] <= q[22] ^ feedback;
            // Bits 20 down to 2 shift right without change
            q[20:2] <= q[21:3];
            // Tap at bit 2 (idx 1): XOR with feedback
            q[1] <= q[2] ^ feedback;
            // Tap at bit 1 (idx 0): XOR with feedback
            q[0] <= q[1] ^ feedback;
        end
    end

endmodule