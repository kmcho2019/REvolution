module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    wire [511:0] left = {1'b0, q[511:1]};    // Left neighbors (q[-1] = 0)
    wire [511:0] right = {q[510:0], 1'b0};   // Right neighbors (q[512] = 0)

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= (left & q & ~right) | (~left & q) | (~q & right);
        end
    end

endmodule