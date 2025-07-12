module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

// LFSR with polynomial x^3 + x^2 + 1 (maximal length for 3 bits)
// Sequence: 4→5→6→0→1→4...
always @(posedge clk) begin
    if (a) begin
        q <= 3'b100;  // reset to 4 when a=1
    end else begin
        // LFSR feedback: tap bits 2 and 1
        q <= {q[1:0], q[2] ^ q[1]};
    end
end

endmodule