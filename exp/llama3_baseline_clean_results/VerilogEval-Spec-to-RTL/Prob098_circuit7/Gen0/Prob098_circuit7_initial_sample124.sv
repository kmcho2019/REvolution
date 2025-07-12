module TopModule(
    input clk,
    input a,
    output reg q
);

always @(posedge clk) begin
    if(a)
        q <= !q;
    else
        q <= q;
end

endmodule