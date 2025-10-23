module TopModule (
    input           clk,
    input           resetn,
    input   [1:0]   byteena,
    input   [15:0]  d,
    output  reg [15:0] q
);

integer i;

always @(posedge clk) begin
    if (!resetn) begin
        q <= 16'b0;
    end else begin
        // Update lower byte if enabled
        if (byteena[0]) begin
            for (i = 0; i < 8; i = i + 1) begin
                q[i] <= d[i];
            end
        end
        // Update upper byte if enabled
        if (byteena[1]) begin
            for (i = 8; i < 16; i = i + 1) begin
                q[i] <= d[i];
            end
        end
        // If a byteena bit is not set, q bits in that byte keep their previous values implicitly
    end
end

endmodule