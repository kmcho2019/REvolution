module TopModule (
    input clk,
    input reset,
    output reg [4:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 5'b00001;
    end else begin
        // Compute feedback as XOR of taps q[0] and q[2]
        wire feedback = q[0] ^ q[2];
        q <= {feedback, q[4:1]};
    end
end

endmodule