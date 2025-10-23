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
        // Construct write mask from byteena bits directly
        q <= (q & ~{ {8{byteena[1]}}, {8{byteena[0]}} }) | (d & { {8{byteena[1]}}, {8{byteena[0]}} });
    end
end

endmodule