module TopModule (
    input clk,
    input j,
    input k,
    output reg Q
);

always @(posedge clk) begin
    if (j & k)
        Q <= ~Q;
    else if (j)
        Q <= 1'b1;
    else if (k)
        Q <= 1'b0;
    // else Q remains unchanged (implicit)
end

endmodule