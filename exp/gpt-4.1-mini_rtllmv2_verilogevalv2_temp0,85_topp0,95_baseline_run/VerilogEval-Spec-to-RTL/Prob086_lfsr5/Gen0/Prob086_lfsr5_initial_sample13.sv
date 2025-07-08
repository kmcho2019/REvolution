module TopModule (
    input clk,
    input reset,
    output reg [4:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 5'b00001;
    end else begin
        // Capture feedback bit
        wire feedback = q[0];
        // Compute next state
        // Shift right by 1
        // For tapped bits (bit 4 and bit 2), XOR with feedback if feedback is 1
        q[0] <= q[1];
        q[1] <= q[2];
        q[2] <= q[3] ^ feedback; // tap at bit 3 (q[2])
        q[3] <= q[4];
        q[4] <= feedback; // tap at bit 5 (q[4]) XORed with feedback: since it's the tap output bit, next bit q[4] = feedback
    end
end

endmodule