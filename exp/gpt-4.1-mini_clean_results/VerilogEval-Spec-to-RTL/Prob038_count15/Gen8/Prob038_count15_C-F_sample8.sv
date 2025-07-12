module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

reg [3:0] next_q;

always @(*) begin
    if (reset)
        next_q = 4'b0000;
    else begin
        // Explicit bitwise increment logic mimicking ripple carry adder:
        next_q[0] = ~q[0];
        next_q[1] = q[1] ^ q[0];
        next_q[2] = q[2] ^ (q[1] & q[0]);
        next_q[3] = q[3] ^ (q[2] & q[1] & q[0]);
    end
end

always @(posedge clk) begin
    q <= next_q;
end

endmodule