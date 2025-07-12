module TopModule(
    input clk,
    input reset,
    output reg [4:0] q
);

wire feedback = q[0] ^ q[2];  // taps at bits 5 and 3 (q[4], q[2]) => for Galois taps at bits 5 and 3, feedback is XOR with q[0], and q[2] tap is XORed into feedback path

always @(posedge clk) begin
    if (reset)
        q <= 5'b00001;
    else
        q <= {feedback, q[4:1]};  // shift right with feedback injected at MSB
end

endmodule