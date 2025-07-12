module TopModule (
    input clk,
    input j,
    input k,
    output reg Q
);

always @(posedge clk) begin
    Q <= (j & k) ? ~Q :
         j ? 1'b1 :
         k ? 1'b0 :
         Q;
end

endmodule