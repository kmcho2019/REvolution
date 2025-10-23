module TopModule (
    input clk,
    input reset,
    output reg [4:0] q
);

always @(posedge clk) begin
    if (reset)
        q <= 5'b00001;
    else begin
        // Feedback is xor of bit positions 5 and 3 (q[4] and q[2]) with q[0]
        wire feedback = q[0] ^ q[2];
        // Shift right and insert feedback at MSB
        q <= {feedback, q[4:1]};
    end
end

endmodule