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
        // Create a mask: each byte selected by byteena
        // Upper byte mask: byteena[1], lower byte mask: byteena[0]
        // Shift byteena bits to byte positions
        // If byteena bit is 1 => update that byte from d, else retain q's byte
        q <= (q & ~{ {8{byteena[1]}}, {8{byteena[0]}} }) | (d & { {8{byteena[1]}}, {8{byteena[0]}} });
    end
end

endmodule