module TopModule (
    input clk,
    input reset,
    output reg [4:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 5'b00001;
    end else begin
        // Compute feedback as XOR of bits with taps and the output bit q[0]
        wire feedback = q[0] ^ q[2] ^ q[4];
        q <= {feedback, q[4:1]};
    end
end

endmodule