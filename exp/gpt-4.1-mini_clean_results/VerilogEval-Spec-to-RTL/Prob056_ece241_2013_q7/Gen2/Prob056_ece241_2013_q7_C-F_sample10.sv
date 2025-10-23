module TopModule (
    input clk,
    input j,
    input k,
    output reg Q
);

wire nextQ;

assign nextQ = (j & ~k)        // Set
             | ((~j) & (~k) & Q) // Hold
             | (j & k & ~Q);   // Toggle

always @(posedge clk) begin
    Q <= nextQ;
end

endmodule