module TopModule(
    input [2:0] a, // 3-bit input
    output reg [15:0] q // 16-bit output
);

always @(*) begin
    q = (a * 16'h334) + 16'h1232; // Implementing the equation q = a * 820 + 4660
end

endmodule