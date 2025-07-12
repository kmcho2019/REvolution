module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    reg [511:0] next_q;

    always @(*) begin
        // Left boundary cell (q[-1] = 0)
        next_q[0] = q[0] ^ (1'b0 | (q[0] & ~q[1]));

        // Middle cells (uniform computation)
        for (integer i = 1; i < 511; i = i + 1) begin
            next_q[i] = q[i] ^ (q[i+1] | (q[i] & ~q[i-1]));
        end

        // Right boundary cell (q[512] = 0)
        next_q[511] = q[511] ^ (1'b0 | (q[511] & ~q[510]));
    end

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

endmodule