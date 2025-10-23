module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 4'b0000;
    end
    else begin
        // Optimized parallel bitwise toggling
        q[0] <= ~q[0];
        q[1] <= q[0] ^ q[1];
        q[2] <= (&q[1:0]) ^ q[2];
        q[3] <= (&q[2:0]) ^ q[3];
    end
end

endmodule