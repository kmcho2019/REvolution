module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            q <= 32'h1;
        end else begin
            // Capture feedback bit (LSB)
            wire feedback = q[0];
            // Shift right by 1
            q <= {1'b0, q[31:1]};
            // Apply taps conditionally when feedback is high
            if (feedback) begin
                // XOR feedback into tap bits 31,21,1,0 (0-based)
                // Use bitwise XOR on only those bits
                q[31] <= q[31] ^ 1'b1;
                q[21] <= q[21] ^ 1'b1;
                q[1]  <= q[1]  ^ 1'b1;
                q[0]  <= q[0]  ^ 1'b1; // Actually LSB already shifted out, but keep consistent
            end
        end
    end

endmodule