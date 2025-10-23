module TopModule(
    input  clk,
    input  a,
    output reg q
);

always @(posedge clk) begin
    if(a) begin
        q <= ~q;
    end else begin
        // Do nothing
    end
end

endmodule