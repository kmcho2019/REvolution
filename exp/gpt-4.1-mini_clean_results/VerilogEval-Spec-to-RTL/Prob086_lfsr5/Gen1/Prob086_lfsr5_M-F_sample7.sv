module TopModule(
    input clk,
    input reset,
    output reg [4:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            q <= 5'b00001; // reset to 1
        end else begin
            // feedback bit is the LSB of current state
            wire feedback = q[0];

            // Compute next state with taps at bits 5 and 3 (q[4] and q[2])
            // Shift right: next_q[0] = q[1], next_q[1] = q[2], etc.
            // Tapped bits XOR with feedback
            q[0] <= q[1];
            q[1] <= q[2];
            q[2] <= q[3] ^ feedback; // tap at bit 3
            q[3] <= q[4];
            q[4] <= q[4] ^ feedback; // tap at bit 5
        end
    end

endmodule