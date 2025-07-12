module TopModule (
    input clk,
    input resetn,
    input [1:0] byteena,
    input [15:0] d,
    output reg [15:0] q
);

always @(posedge clk) begin
    if (!resetn) begin
        q <= 16'b0;
    end else begin
        // Upper byte update
        if (byteena[1]) q[15:8] <= d[15:8];
        // Lower byte update
        if (byteena[0]) q[7:0] <= d[7:0];
    end
end

endmodule