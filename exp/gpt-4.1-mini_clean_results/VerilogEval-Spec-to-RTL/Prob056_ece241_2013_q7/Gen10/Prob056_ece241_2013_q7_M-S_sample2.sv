module TopModule (
    input clk,
    input j,
    input k,
    output reg Q
);

always @(posedge clk) begin
    if (j == 0 && k == 0)
        Q <= Q;
    else if (j == 0 && k == 1)
        Q <= 1'b0;
    else if (j == 1 && k == 0)
        Q <= 1'b1;
    else // j == 1 && k == 1
        Q <= ~Q;
end

endmodule