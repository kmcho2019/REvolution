module TopModule(
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

reg [511:0] q;

always @(posedge clk) begin
    if (load) begin
        q <= data;
    end else begin
        for (int i = 0; i < 512; i++) begin
            if (i == 0) begin
                q[i] <= (0 ^ q[i] ^ q[i + 1]);
            end else if (i == 511) begin
                q[i] <= (q[i - 1] ^ q[i] ^ 0);
            end else begin
                q[i] <= (q[i - 1] ^ q[i] ^ q[i + 1]);
            end
        end
    end
end

endmodule