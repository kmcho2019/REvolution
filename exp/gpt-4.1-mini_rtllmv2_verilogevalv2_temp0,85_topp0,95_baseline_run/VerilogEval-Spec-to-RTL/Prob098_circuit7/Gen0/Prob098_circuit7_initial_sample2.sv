module TopModule (
    input clk,
    input a,
    output reg q
);

reg prev_a;

always @(posedge clk) begin
    if (prev_a == 1'b1 && a == 1'b1)
        q <= 1'b0;
    else if (prev_a == 1'b0 && a == 1'b0)
        q <= 1'b1;
    else
        q <= q;
    prev_a <= a;
end

endmodule