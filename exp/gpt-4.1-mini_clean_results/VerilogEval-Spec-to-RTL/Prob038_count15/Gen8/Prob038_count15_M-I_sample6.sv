module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

reg [3:0] next_q;

always @(*) begin
    // Ripple carry increment logic
    // next_q = q + 1 implemented with XOR and AND to reduce carry delay
    next_q[0] = ~q[0];
    next_q[1] = q[1] ^ q[0];
    next_q[2] = q[2] ^ (q[1] & q[0]);
    next_q[3] = q[3] ^ (q[2] & q[1] & q[0]);
end

always @(posedge clk) begin
    if (reset)
        q <= 4'b0000;
    else
        q <= next_q;
end

endmodule