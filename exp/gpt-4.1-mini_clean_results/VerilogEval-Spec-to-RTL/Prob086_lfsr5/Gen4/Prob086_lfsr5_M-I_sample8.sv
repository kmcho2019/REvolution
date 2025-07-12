module TopModule (
    input clk,
    input reset,
    output reg [4:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 5'b00001;  // Initialize to 1 on reset
    end else begin
        // feedback from LSB
        wire feedback = q[0];
        // Next state calculation for Galois LFSR with taps at bits 5 and 3 (q[4], q[2])
        // shift right by one bit with tap feedback applied
        q <= {feedback, q[4] ^ feedback, q[3], q[2] ^ feedback, q[1]};
    end
end

endmodule