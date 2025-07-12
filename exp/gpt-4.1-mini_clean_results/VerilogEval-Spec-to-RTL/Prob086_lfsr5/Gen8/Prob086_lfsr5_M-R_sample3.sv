module TopModule (
    input           clk,
    input           reset,
    output reg [4:0] q
);

    wire feedback;
    wire [4:0] next_q;

    // feedback is the LSB of current state q[0]
    assign feedback = q[0];

    // next state logic for Galois LFSR with taps at bits 5 and 3 (q[4] and q[2])
    assign next_q[4] = feedback;           // q[4] <= feedback (tap)
    assign next_q[3] = q[4];               // q[3] shifts right by one bit
    assign next_q[2] = q[3] ^ feedback;   // q[2] tapped, XOR with feedback
    assign next_q[1] = q[2];               // q[1] shifts right by one bit
    assign next_q[0] = q[1];               // q[0] shifts right by one bit

    always @(posedge clk) begin
        if (reset) begin
            q <= 5'b00001; // synchronous reset to 1
        end else begin
            q <= next_q;
        end
    end

endmodule