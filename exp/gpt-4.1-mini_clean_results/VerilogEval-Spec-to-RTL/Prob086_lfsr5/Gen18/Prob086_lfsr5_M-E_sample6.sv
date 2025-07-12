module TopModule(
    input clk,
    input reset,
    output reg [4:0] q
);

wire feedback = q[0] ^ q[2]; // taps at bit 5 (q[4]) and bit 3 (q[2]) xor'ed with q[0]
wire [4:0] next_state = {q[3], q[4], q[2] ^ q[0], q[1], q[0]};

always @(posedge clk) begin
    if (reset)
        q <= 5'b00001;
    else
        q <= next_state;
end

endmodule