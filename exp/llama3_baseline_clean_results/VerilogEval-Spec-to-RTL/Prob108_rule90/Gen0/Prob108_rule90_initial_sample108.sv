module TopModule (
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
                q[i] <= q[i + 1] ^ 1'b0;  // Left boundary
            end else if (i == 511) begin
                q[i] <= q[i - 1] ^ 1'b0;  // Right boundary
            end else begin
                q[i] <= q[i - 1] ^ q[i + 1];  // Normal cell
            end
        end
    end
end

endmodule