module TopModule (
    input        clk,
    input        resetn,
    input  [1:0] byteena,
    input  [15:0] d,
    output reg [15:0] q
);

reg [15:0] q_next;

always @* begin
    // Start from current q
    q_next = q;
    if (byteena[0])
        q_next[7:0] = d[7:0];
    if (byteena[1])
        q_next[15:8] = d[15:8];
end

always @(posedge clk) begin
    if (!resetn)
        q <= 16'b0;
    else
        q <= q_next;
end

endmodule