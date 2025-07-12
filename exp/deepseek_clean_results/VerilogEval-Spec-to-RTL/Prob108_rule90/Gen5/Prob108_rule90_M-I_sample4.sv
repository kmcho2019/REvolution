module TopModule (
    input clk,
    input load,
    input enable,
    input [511:0] data,
    output reg [511:0] q
);

    // Pipeline registers
    reg [511:0] q_next;

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else if (enable) begin
            q <= q_next;
        end
    end

    // Combinational logic with explicit boundary handling
    always @(*) begin
        // Left boundary (q[-1] = 0)
        q_next[0] = 1'b0 ^ q[1];
        
        // Middle bits
        for (integer i = 1; i < 511; i = i + 1) begin
            q_next[i] = q[i-1] ^ q[i+1];
        end
        
        // Right boundary (q[512] = 0)
        q_next[511] = q[510] ^ 1'b0;
    end

endmodule