module TopModule (
    input clk,
    input reset,
    output reg [3:0] q = 0
);

reg [3:0] q_next;

always @(posedge clk) begin
    if (reset) begin
        q <= 4'd0;
    end else begin
        q <= q + 1;
    end
end

// Alternatively, for a more novel approach without using '+' operator directly:
// always @(posedge clk) begin
//     if (reset) begin
//         q <= 4'd0;
//     end else begin
//         q_next[0] = ~q[0];
//         q_next[1] = q[1] ^ q[0];
//         q_next[2] = q[2] ^ (q[1] & q[0]);
//         q_next[3] = q[3] ^ (q[2] & q[1] & q[0]);
//         q <= q_next;
//     end
// end

endmodule