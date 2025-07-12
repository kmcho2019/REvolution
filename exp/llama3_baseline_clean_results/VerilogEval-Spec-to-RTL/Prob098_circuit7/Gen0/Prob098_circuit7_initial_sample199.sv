module TopModule(
    input  clk,
    input  a,
    output reg q
);

always @(posedge clk) begin
    if(a) begin
        q <= ~q;
    end else begin
        // hold the previous state when a is 0
    end
end

endmodule