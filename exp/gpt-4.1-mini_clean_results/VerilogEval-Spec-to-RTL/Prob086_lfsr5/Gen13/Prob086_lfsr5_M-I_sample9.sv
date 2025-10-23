module TopModule(
    input clk,
    input reset,
    output reg [4:0] q
);

// Compute feedback bit as XOR of q[4], q[2], and q[0]
wire feedback = q[4] ^ q[2] ^ q[0];

always @(posedge clk) begin
    if (reset)
        q <= 5'b00001;
    else begin
        // Shift right by one bit; MSB gets feedback
        q <= {feedback, q[4:1]};
    end
end

endmodule