module TopModule (
    input  clk,
    input  load,
    input  [511:0] data,
    output [511:0] q
);

reg [511:0] q;

always @(posedge clk) begin
    if (load) begin
        q <= data;
    end else begin
        for (int i = 0; i < 512; i++) begin
            if (i == 0) begin
                q[i] <= ~(data[0] ^ data[1]); // Left boundary
            end else if (i == 511) begin
                q[i] <= ~(data[510] ^ data[511]); // Right boundary
            end else begin
                q[i] <= ~(data[i-1] ^ data[i+1]); // Normal cells
            end
        end
    end
end

endmodule