module TopModule (
    input           clk,
    input           resetn,
    input   [1:0]   byteena,
    input   [15:0]  d,
    output  reg [15:0] q
);

    // Precompute mask once for clarity and synthesis friendliness:
    // byteena[1] controls upper byte, byteena[0] controls lower byte
    wire [15:0] mask = { {8{byteena[1]}}, {8{byteena[0]}} };

    always @(posedge clk) begin
        if (!resetn) begin
            q <= 16'b0;
        end else begin
            // Update only enabled bytes using mask: preserve other bytes from q,
            // update enabled bytes from d.
            q <= (q & ~mask) | (d & mask);
        end
    end

endmodule