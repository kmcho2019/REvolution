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
        // Apply Rule 90 to all cells
        for (integer i = 0; i < 512; i = i + 1) begin
            // Left neighbor is q[i-1] or 0 if i=0
            // Right neighbor is q[i+1] or 0 if i=511
            q[i] <= (i == 0 ? 1'b0 : q[i-1]) ^ (i == 511 ? 1'b0 : q[i+1]);
        end
    end
end

endmodule