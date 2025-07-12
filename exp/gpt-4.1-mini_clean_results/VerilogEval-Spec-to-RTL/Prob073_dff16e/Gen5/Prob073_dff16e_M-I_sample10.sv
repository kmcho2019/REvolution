module TopModule (
    input           clk,
    input           resetn,
    input   [1:0]   byteena,
    input   [15:0]  d,
    output  reg [15:0] q
);

wire upper_enable = byteena[1];
wire lower_enable = byteena[0];

always @(posedge clk) begin
    if (!resetn) begin
        q <= 16'b0;
    end else begin
        // Update upper byte only if enabled
        if (upper_enable)
            q[15:8] <= d[15:8];
        // Update lower byte only if enabled
        if (lower_enable)
            q[7:0] <= d[7:0];
        // When not enabled, bytes hold their values implicitly
    end
end

endmodule