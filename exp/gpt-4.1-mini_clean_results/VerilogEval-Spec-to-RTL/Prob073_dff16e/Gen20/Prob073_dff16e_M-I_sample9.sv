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
        // Create 16-bit write mask from byte enables
        // byteena[1] controls upper byte, byteena[0] controls lower byte
        // If byteena bit is 1, corresponding byte bits from d are latched; otherwise q retained
        q <= ({8{byteena[1]}} & d[15:8]) << 8 | ({8{byteena[0]}} & d[7:0]) 
             | (q & ~({8{byteena[1]}} << 8 | {8{byteena[0]}}));
    end
end

endmodule