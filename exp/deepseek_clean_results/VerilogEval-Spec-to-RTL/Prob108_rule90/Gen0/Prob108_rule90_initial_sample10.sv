module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    reg [511:0] q_next;

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= q_next;
        end
    end

    always @(*) begin
        // Compute next state for each cell
        q_next[0] = 0 ^ q[1];               // Left neighbor is 0 (boundary)
        q_next[511] = q[510] ^ 0;           // Right neighbor is 0 (boundary)
        
        for (integer i = 1; i < 511; i = i + 1) begin
            q_next[i] = q[i-1] ^ q[i+1];
        end
    end

endmodule