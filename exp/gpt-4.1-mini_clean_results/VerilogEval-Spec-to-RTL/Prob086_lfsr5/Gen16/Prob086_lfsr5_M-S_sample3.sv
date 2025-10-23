module TopModule(
    input clk,
    input reset,
    output reg [4:0] q
);

always @(posedge clk) begin
    if (reset)
        q <= 5'b00001;
    else begin
        wire feedback = q[0] ^ q[2]; // taps at bits 5 (q[4]) and 3 (q[2]), feedback is XOR of q[0] and tap q[2]
        q <= {feedback, q[4:1]};
    end
end

endmodule