module TopModule (
    input           clk,
    input           resetn,
    input   [1:0]   byteena,
    input   [15:0]  d,
    output  reg [15:0] q
);

    // Create 16-bit mask: upper byte replicated from byteena[1], lower byte from byteena[0]
    wire [15:0] mask = { {8{byteena[1]}}, {8{byteena[0]}} };
    wire update_en = (byteena != 2'b00);

    always @(posedge clk) begin
        if (!resetn) begin
            q <= 16'b0;
        end else if (update_en) begin
            // Selectively update bytes based on mask: keep old bits where mask=0
            q <= (q & ~mask) | (d & mask);
        end
        // else retain previous q without toggling
    end

endmodule