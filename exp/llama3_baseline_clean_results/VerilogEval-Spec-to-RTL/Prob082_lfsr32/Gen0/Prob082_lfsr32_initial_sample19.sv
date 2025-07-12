module TopModule (
    input clk,
    input reset,
    output [31:0] q
);

reg [31:0] q_next;
assign q = q_next;

always @(posedge clk) begin
    if (reset) begin
        q_next <= 32'h1;
    end else begin
        q_next[31] <= q[30];
        q_next[30:22] <= q[21:13];
        q_next[21] <= q[20] ^ q[0];
        q_next[20:2] <= q[1:1];
        q_next[1] <= q[0] ^ q[0];
        q_next[0] <= q[31] ^ q[21] ^ q[1];
    end
end

endmodule