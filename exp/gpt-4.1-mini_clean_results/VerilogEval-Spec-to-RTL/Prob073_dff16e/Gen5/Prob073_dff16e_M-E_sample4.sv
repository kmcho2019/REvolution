module TopModule (
    input         clk,
    input         resetn,
    input  [1:0]  byteena,
    input  [15:0] d,
    output reg [15:0] q
);

always @(posedge clk) begin
    if (!resetn) begin
        q <= 16'b0;
    end else begin
        // Create mask for upper and lower bytes based on byteena
        // byteena[1]: upper byte mask (bits 15:8)
        // byteena[0]: lower byte mask (bits 7:0)
        // Combine masks into one 16-bit mask
        wire [15:0] mask = { {8{byteena[1]}}, {8{byteena[0]}} };
        // Update q by selecting bytes from d or retaining from q using mask
        q <= (q & ~mask) | (d & mask);
    end
end

endmodule