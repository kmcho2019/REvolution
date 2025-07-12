module TopModule (
    input          clk,
    input          resetn,
    input   [1:0]  byteena,
    input  [15:0]  d,
    output reg [15:0] q
);

always @(posedge clk) begin
    if (!resetn)
        q <= 16'b0;
    else begin
        // Create mask from byteena: byteena[1] for upper byte, byteena[0] for lower byte
        // If byteena bit is 1, update that byte from d; else retain old value
        q <= (q & { {8{~byteena[1]}}, {8{~byteena[0]}} }) // Keep old bytes where byteena=0
             | ( {d[15:8] & {8{byteena[1]}}, d[7:0] & {8{byteena[0]}}} ); // Update bytes where byteena=1
    end
end

endmodule