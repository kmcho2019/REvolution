module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

    // Taps at bits 32,22,2,1 correspond to indices 31,21,1,0 (zero-based)
    wire feedback = q[0];

    always @(posedge clk) begin
        if (reset) begin
            q <= 32'h1;
        end else begin
            // Shift right by one, insert feedback at MSB
            // XOR feedback with tapped bits before shifting in
            q[31] <= feedback;
            q[30:22] <= q[31:23];
            q[21] <= q[22] ^ feedback;  // tap bit
            q[20:2] <= q[21:3];
            q[1] <= q[2] ^ feedback;    // tap bit
            q[0] <= q[1] ^ feedback;    // tap bit (LSB)
        end
    end

endmodule