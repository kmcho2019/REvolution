module TopModule(
    input        clk,
    input        reset,
    output reg [4:0] q
);

    wire feedback = q[0];  // feedback tap from LSB

    always @(posedge clk) begin
        if (reset) begin
            q <= 5'b00001; // reset to non-zero state
        end else begin
            // Shift right with XOR feedback applied to tapped bits 5 (q[4]) and 3 (q[2])
            q[0] <= q[1];
            q[1] <= q[2];
            q[2] <= q[3] ^ feedback; // tap at bit 3
            q[3] <= q[4];
            q[4] <= feedback;        // tap at bit 5
        end
    end

endmodule