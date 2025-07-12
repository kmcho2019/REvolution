module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

    // Tap positions (0-based indexing): 31, 21, 1, 0
    wire feedback = q[0];

    integer i;

    always @(posedge clk) begin
        if (reset) begin
            q <= 32'h1;
        end else begin
            // Shift right by 1, apply XOR feedback on taps
            q[0] <= q[1] ^ (feedback & (1'b1));        // tap at bit 1 (LSB)
            q[1] <= q[2] ^ (feedback & (1'b1));        // tap at bit 2
            for (i = 2; i < 21; i = i + 1) begin
                q[i] <= q[i+1];
            end
            q[21] <= q[22] ^ (feedback & 1'b1);        // tap at bit 22
            for (i = 22; i < 31; i = i + 1) begin
                q[i] <= q[i+1];
            end
            q[31] <= feedback ^ q[31];                   // tap at bit 32 (MSB)
        end
    end

endmodule