module TopModule(
    input  clk,
    input  a,
    output reg q
);

always @(posedge clk) begin
    if (~a) begin
        q <= 1;
    end else if (q) begin
        q <= 0;
    end
end

endmodule