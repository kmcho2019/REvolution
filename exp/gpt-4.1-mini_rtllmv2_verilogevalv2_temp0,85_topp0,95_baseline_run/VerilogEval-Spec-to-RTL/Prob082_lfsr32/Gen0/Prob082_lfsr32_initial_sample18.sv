module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

    // Tap positions: 32,22,2,1 correspond to bits q[31], q[21], q[1], q[0]
    always @(posedge clk) begin
        if (reset) begin
            q <= 32'h1;
        end else begin
            wire feedback = q[0];
            reg [31:0] next_q;

            next_q[31] = q[30];
            // Bits 30 down to 22 shift right normally except bit 21 XOR feedback
            next_q[30:22] = q[29:21];
            next_q[21] = q[21] ^ feedback; // tap
            // Bits 20 down to 2 shift right normally except bit 1 XOR feedback
            next_q[20:2] = q[19:1];
            next_q[1] = q[1] ^ feedback;   // tap
            next_q[0] = q[0] ^ feedback;   // tap (bit 1)
            
            q <= next_q;
        end
    end

endmodule