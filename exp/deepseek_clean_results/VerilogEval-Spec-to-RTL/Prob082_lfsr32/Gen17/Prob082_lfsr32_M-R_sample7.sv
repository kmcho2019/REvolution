module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

wire [31:0] next_q;

assign next_q = reset ? 32'h1 : {
    q[31] ^ q[0],  // Tap at bit 31 (1-based 32)
    q[30:22],
    q[21] ^ q[0],  // Tap at bit 21 (1-based 22)
    q[20:2],
    q[1] ^ q[0],   // Tap at bit 1 (1-based 2)
    q[0] ^ q[0]    // Tap at bit 0 (1-based 1)
};

always @(posedge clk) begin
    q <= next_q;
end

endmodule