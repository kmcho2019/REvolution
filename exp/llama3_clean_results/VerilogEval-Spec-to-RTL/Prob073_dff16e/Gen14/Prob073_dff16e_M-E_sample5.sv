module TopModule(
    input clk,
    input resetn,
    input [1:0] byteena,
    input [15:0] d,
    output reg [15:0] q
);

always @(posedge clk) begin
    if (~resetn) begin
        // Synchronous reset: Set the entire register to zero
        q <= 16'd0;
    end else begin
        // Upper byte update
        if (byteena[1]) begin
            q[15:8] <= d[15:8];
        end
        // Lower byte update
        if (byteena[0]) begin
            q[7:0] <= d[7:0];
        end
    end
end

endmodule