module TopModule(
    input  clk,
    input  load,
    input  [511:0] data,
    output [511:0] q
);

reg [511:0] q;

integer i;

always @(posedge clk) begin
    if (load) begin
        q <= data;
    end else begin
        for (i = 0; i < 512; i = i + 1) begin
            if (i == 0) begin
                // Left boundary is always 0
                q[i] <= q[i + 1];
            end else if (i == 511) begin
                // Right boundary is always 0
                q[i] <= q[i - 1];
            end else begin
                // Apply Rule 90
                q[i] <= q[i - 1] ^ q[i + 1];
            end
        end
    end
end

endmodule