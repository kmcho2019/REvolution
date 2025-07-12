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
        // Create byte masks
        // byteena[1]: upper byte, byteena[0]: lower byte
        // Generate 16-bit mask from byte enables
        wire [15:0] mask = { {8{byteena[1]}}, {8{byteena[0]}} };
        q <= (q & ~mask) | (d & mask);
    end
end

endmodule