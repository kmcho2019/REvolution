module TopModule(
    input clk,
    input reset,
    output reg [4:0] q
);

wire feedback = q[0] ^ q[2] ^ q[4]; // taps at bit positions 5 and 3 (q[4], q[2])

always @(posedge clk) begin
    if (reset)
        q <= 5'b00001;
    else
        q <= {feedback, q[4:1]};
end

endmodule