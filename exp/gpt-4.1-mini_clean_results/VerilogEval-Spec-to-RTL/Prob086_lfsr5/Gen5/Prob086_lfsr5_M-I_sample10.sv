module TopModule(
    input clk,
    input reset,
    output reg [4:0] q
);

wire feedback = q[0] ^ q[2]; // taps at positions 5 (q[4]) and 3 (q[2]); feedback = q0 XOR q2

always @(posedge clk) begin
    if (reset)
        q <= 5'b00001;
    else
        q <= {q[3:0], feedback};
end

endmodule