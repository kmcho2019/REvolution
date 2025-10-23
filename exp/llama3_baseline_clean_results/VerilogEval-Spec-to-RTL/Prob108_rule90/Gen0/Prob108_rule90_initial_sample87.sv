module TopModule(
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

reg [511:0] next_q;

always @(*) begin
    for (int i = 0; i < 512; i++) begin
        if (i == 0) begin
            // Left boundary is always zero
            next_q[i] = q[i+1] ^ 0;
        end else if (i == 511) begin
            // Right boundary is always zero
            next_q[i] = q[i-1] ^ 0;
        end else begin
            // General case: XOR of left and right neighbors
            next_q[i] = q[i-1] ^ q[i+1];
        end
    end
end

always @(posedge clk) begin
    if (load) begin
        q <= data;
    end else begin
        q <= next_q;
    end
end

endmodule