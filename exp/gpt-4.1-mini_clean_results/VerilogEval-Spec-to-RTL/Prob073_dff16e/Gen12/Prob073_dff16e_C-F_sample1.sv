module TopModule (
    input           clk,
    input           resetn,
    input   [1:0]   byteena,
    input   [15:0]  d,
    output  reg [15:0] q
);

    // Explicit bytewise mask: upper byte enabled by byteena[1], lower by byteena[0]
    wire [15:0] mask = { (byteena[1] ? 8'hFF : 8'h00), (byteena[0] ? 8'hFF : 8'h00) };

    always @(posedge clk) begin
        if (!resetn) begin
            q <= 16'b0;
        end else begin
            q <= (q & ~mask) | (d & mask);
        end
    end

endmodule