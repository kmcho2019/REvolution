module TopModule (
    input        clk,
    input        reset,
    output reg [4:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            q <= 5'b00001; // synchronous reset to 1
        end else begin
            // feedback bit (LSB before shift)
            // Shift right by one bit:
            // q[4] <= feedback (q[0])
            // q[3] <= q[4]
            // q[2] <= q[3] XOR feedback (tap)
            // q[1] <= q[2]
            // q[0] <= q[1]
            q <= {q[0], q[4], q[3] ^ q[0], q[2], q[1]};
        end
    end

endmodule