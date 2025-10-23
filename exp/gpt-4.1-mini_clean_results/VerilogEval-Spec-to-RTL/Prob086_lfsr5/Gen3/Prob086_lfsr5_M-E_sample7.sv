module TopModule (
    input wire clk,
    input wire reset,
    output reg [4:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 5'b00001;
    end else begin
        // Capture feedback bit
        wire fb = q[0];
        // Compute next state with Galois taps at bit 5 (q[4]) and bit 3 (q[2])
        q <= {fb, q[4] ^ fb, q[3], q[2] ^ fb, q[1]};
    end
end

endmodule