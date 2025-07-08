module TopModule (
    input clk,
    input reset,
    output reg [4:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 5'b00001;
    end else begin
        // feedback bit is the LSB of current q
        wire feedback = q[0];
        // Compute next state for each bit:
        // For bit 4 (tap at position 5): next_q[4] = q[3] XOR feedback
        // For bit 3: next_q[3] = q[2] (no tap)
        // For bit 2 (tap at position 3): next_q[2] = q[1] XOR feedback
        // For bit 1: next_q[1] = q[0] (no tap)
        // For bit 0: next_q[0] = feedback
        q[4] <= q[3] ^ feedback;
        q[3] <= q[2];
        q[2] <= q[1] ^ feedback;
        q[1] <= q[0];
        q[0] <= feedback;
    end
end

endmodule