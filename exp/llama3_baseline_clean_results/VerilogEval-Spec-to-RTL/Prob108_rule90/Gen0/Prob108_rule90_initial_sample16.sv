module TopModule(
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

reg [511:0] q_next;

always @(*) begin
    for (int i = 0; i < 512; i++) begin
        if (i == 0) begin
            // Handle left boundary
            q_next[i] = q[0] ^ q[1];
        end else if (i == 511) begin
            // Handle right boundary
            q_next[i] = q[510] ^ q[511];
        end else begin
            q_next[i] = q[i-1] ^ q[i+1];
        end
    end
end

always @(posedge clk) begin
    if (load) begin
        q <= data;
    end else begin
        q <= q_next;
    end
end

endmodule