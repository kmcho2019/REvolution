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
        // Construct byte mask based on byteena signals
        // byteena[1] controls upper byte, byteena[0] controls lower byte
        // For each byte, if enabled, take d, else keep previous q
        q <= ({16{byteena[1]}} & {8{2'b11}, d[15:8]}) |
             ({16{byteena[0]}} & {8{2'b11}, d[7:0]}) |
             (q & ~({16{byteena[1]}} | {16{byteena[0]}}));
        // Above is more complex than needed; better to do byte-wise mask:
        // We'll build masks per byte and assign q = (q & ~mask) | (d & mask);
    end
end

endmodule