module TopModule(
    input clk,
    input reset,
    output reg [4:0] q
);

wire feedback;
assign feedback = q[0] ^ q[2] ^ q[4]; // taps at bit 5 (q[4]) and bit 3 (q[2]) XORed with q[0]

always @(posedge clk) begin
    if (reset)
        q <= 5'b00001;  // non-zero seed on synchronous reset
    else
        q <= {feedback, q[4:1]};  // shift right and insert feedback at MSB
end

endmodule