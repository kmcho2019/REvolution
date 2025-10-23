module TopModule(
    input clk,
    input resetn,
    input [1:0] byteena,
    input [15:0] d,
    output reg [15:0] q
);

always @(posedge clk) begin
    if (~resetn) begin
        // Initialize with reset value
        q <= 16'd0;
    end else begin
        // Update bytes based on byte-enable signals
        if (byteena[0]) begin
            // Update lower byte
            q[7:0] <= d[7:0];
        end
        if (byteena[1]) begin
            // Update upper byte
            q[15:8] <= d[15:8];
        end
    end
end

endmodule