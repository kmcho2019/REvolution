module TopModule (
    input clk,
    input j,
    input k,
    output reg Q
);

always @(posedge clk) begin
    Q <= (j & k) ? ~Q :  // Optimized toggle case
         (j) ? 1'b1 :    // Set case (j=1)
         (k) ? 1'b0 :     // Reset case (k=1)
         Q;               // Hold case
end

endmodule