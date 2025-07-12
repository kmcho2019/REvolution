module TopModule (
    input clk,
    input j,
    input k,
    output reg Q
);

reg Qnext;
reg update_enable;

always @(*) begin
    Qnext = (j & ~Q) | (~k & Q);
    update_enable = j | k;
end

always @(posedge clk) begin
    if (update_enable)
        Q <= Qnext;
end

endmodule