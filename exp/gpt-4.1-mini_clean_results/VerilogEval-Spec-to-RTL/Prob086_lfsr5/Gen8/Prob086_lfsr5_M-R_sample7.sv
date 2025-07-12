module TopModule(
    input clk,
    input reset,
    output reg [4:0] q
);

wire feedback;
assign feedback = q[0] ^ q[2]; // taps at positions 5 (q[4]) and 3 (q[2]) shifted right, feedback is XOR of q[0] and q[2]

always @(posedge clk) begin
    if (reset)
        q <= 5'b00001;
    else
        q <= {feedback, q[4:1]};
end

endmodule