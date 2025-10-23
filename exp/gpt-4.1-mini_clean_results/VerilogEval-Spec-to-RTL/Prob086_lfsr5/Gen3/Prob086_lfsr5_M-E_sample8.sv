module TopModule(
    input clk,
    input reset,
    output reg [4:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 5'b00001;
    end else begin
        // Save the output bit (LSB) before shift for feedback
        wire feedback = q[0];
        // Shift right and apply XOR feedback at taps 5 and 3 (q[4] and q[2])
        q[0] <= q[1];
        q[1] <= q[2];
        q[2] <= q[3] ^ feedback;  // tap bit 3
        q[3] <= q[4];
        q[4] <= feedback;         // tap bit 5
    end
end

endmodule