module TopModule (
    input clk,
    input reset,
    output reg [4:0] q
);

    // On reset, set q to 1. Otherwise, update q with Galois LFSR next state.
    always @(posedge clk) begin
        if (reset) begin
            q <= 5'b00001;
        end else begin
            // Extract LSB which is shifted out
            wire feedback = q[0];
            // Compute next state bits
            // bit 4 (position 5) taps: next q[4] = q[3] ^ feedback
            // bit 2 (position 3) taps: next q[2] = q[1] ^ feedback
            // bits 3,1,0 shift right without XOR: q[3] = q[4], q[1] = q[2], q[0] = q[1]
            q[4] <= q[3] ^ feedback;
            q[3] <= q[4];
            q[2] <= q[1] ^ feedback;
            q[1] <= q[2];
            q[0] <= q[1];
        end
    end

endmodule