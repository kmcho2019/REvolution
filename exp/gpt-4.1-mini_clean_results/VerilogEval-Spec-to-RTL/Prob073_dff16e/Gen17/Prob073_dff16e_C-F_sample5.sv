module TopModule (
    input           clk,
    input           resetn,
    input   [1:0]   byteena,
    input   [15:0]  d,
    output reg [15:0] q
);

    // Create write mask: upper byte enable expands to bits [15:8], lower byte enable to [7:0]
    wire [15:0] write_mask = { {8{byteena[1]}}, {8{byteena[0]}} };

    always @(posedge clk) begin
        if (!resetn)
            q <= 16'b0;
        else
            // Update only bits enabled by write_mask; others retain their value
            q <= (q & ~write_mask) | (d & write_mask);
    end

endmodule