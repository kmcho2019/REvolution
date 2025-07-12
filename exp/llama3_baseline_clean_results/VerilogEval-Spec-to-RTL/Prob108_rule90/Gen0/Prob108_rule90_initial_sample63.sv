module TopModule(
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

always @(posedge clk) begin
    if (load) begin
        q <= data;
    end else begin
        for (int i = 0; i < 512; i++) begin
            if (i == 0) begin
                // Left boundary, left neighbor is always 0
                q[i] <= q[i+1];
            end else if (i == 511) begin
                // Right boundary, right neighbor is always 0
                q[i] <= q[i-1];
            end else begin
                // General case, XOR of left and right neighbors
                q[i] <= q[i-1] ^ q[i+1];
            end
        end
    end
end

endmodule