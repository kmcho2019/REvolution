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
            // MSB tap at bit 31 (pos 32)
            q[31] <= feedback;
            // Bits 30 down to 22 shift right by one
            q[30:22] <= q[31:23];
            // Tap at bit 21 (pos 22) XOR with feedback
            q[21] <= q[22] ^ feedback;
            // Bits 20 down to 2 shift right by one
            q[20:2] <= q[21:3];
            // Tap at bit 1 (pos 2) XOR with feedback
            q[1] <= q[2] ^ feedback;
            // Tap at bit 0 (pos 1) XOR with feedback
            q[0] <= q[1] ^ feedback;
        end
    end

endmodule