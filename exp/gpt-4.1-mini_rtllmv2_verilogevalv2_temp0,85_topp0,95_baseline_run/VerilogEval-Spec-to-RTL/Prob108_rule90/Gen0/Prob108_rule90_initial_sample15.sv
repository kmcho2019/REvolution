module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    reg [511:0] q_next;

    integer i;
    always @(*) begin
        // Compute next state based on Rule 90
        // Boundary neighbors assumed zero
        q_next[0] = q[1];               // left neighbor = 0 XOR right neighbor = q[1]
        for (i = 1; i < 511; i = i + 1) begin
            q_next[i] = q[i-1] ^ q[i+1];
        end
        q_next[511] = q[510];           // left neighbor = q[510] XOR right neighbor = 0
    end

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= q_next;
        end
    end

endmodule